// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "../Data.sol";
import "../InterestRateModel.sol";

library WithdrawManager {
    //@Borrower -- withdraw loan and create lp token
    function acceptLoanWithdrawLoan(
        string memory _name,
        string memory _symbol,
        Data storage dt
    ) external //require dao
    {
        uint256 _currentTime = block.timestamp;
        require(
            _currentTime > dt.endOfRaise &&
                _currentTime < dt.endBorrowerAcceptWindow,
            "TOGGE: OUT_OF_TIME_WINDOW"
        );

        require(!dt.loanAccepted, "TOGGE: LOAN_ALREADY_ACCEPTED");
        dt.loanAccepted = true;

        (bool sent, ) = payable(msg.sender).call{value: dt.ethSupplied}("");
        require(sent, "TOGGE: FAILED_SEND");
        dt.LPnfts = new GGETH(_name, _symbol);
        dt.ultimoPago = block.timestamp;
        //interes de riesgo + togge cut
        dt.interesTotal =
            InterestRateModel.getBorrowRate(
                dt.goalAmount,
                dt.ethSupplied,
                dt.multiplier
            ) +
            dt.reserveFactorMantissa;

        dt.deudaTotal = dt.ethSupplied * (1e18 + dt.interesTotal);

        //se calcula el total a pagar de el DAO
        dt.deudaActual = dt.deudaTotal;
    }

    //@LP -- withdarw deposit if failed loan
    function withdrawFailedDeposits(Data storage dt) external {
        require(!dt.loanAccepted, "TOGGE: LOAN_ACCEPTED");
        require(dt.deposits[msg.sender] != 0, "TOGGE: NO_VALUE");

        uint256 _deposit = dt.deposits[msg.sender];
        dt.deposits[msg.sender] = 0;
        (bool sent, ) = payable(msg.sender).call{value: _deposit}("");
        require(sent, "TOGGE: FAILED_SEND");
    }

    // LP -- mint lp token
    function withdrawLPtoken(Data storage dt) external {
        require(dt.loanAccepted, "TOGGE: LOAN_NOT_ACCEPTED");
        require(dt.deposits[msg.sender] != 0, "TOGGE: NO_VALUE");
        require(!dt.nftClaimed[msg.sender], "TOGGE: ClAIMED");

        uint256 _currentTime = block.timestamp;
        require(
            _currentTime > dt.endBorrowerAcceptWindow,
            "TOGGE: OUT_OF_TIME_WINDOW"
        );

        dt.nftClaimed[msg.sender] = true;
        dt.LPnfts.mint(msg.sender, dt.nftCounter, dt.deposits[msg.sender]);
        dt.nftCounter++;
    }

    // @LP - withdraw deposit + interest
    function withdraw(Data storage dt) external {
        uint256 index = dt.indexing[msg.sender];
        bool primero = index == 0 &&
            dt.accum[index] <= dt.valorDAORecibido - dt.valorRetiroLPs;
        bool segundo = true;
        uint256 yaSaco = 0;
        if (index > 0) {
            segundo =
                dt.accum[index - 1] < dt.valorDAORecibido - dt.valorRetiroLPs; //
            yaSaco =
                dt.accum[index] -
                dt.accum[index - 1] -
                dt.deposits[msg.sender];
        }
        require(segundo || primero, "not eligible");
        require(dt.deposits[msg.sender] > 0, "insufficient Funds");
        uint256 min = 0;

        if (index > 0) {
            //si la diferencia es menor a lo que tiene el LP, entonces que el valor que pueda retirar sea esa diferencia menoor
            require(
                dt.accum[index - 1] + yaSaco < dt.valorDAORecibido,
                "can't withdraw more"
            );
            min = dt.valorDAORecibido - dt.accum[index - 1] <
                dt.deposits[msg.sender]
                ? dt.valorDAORecibido - dt.accum[index - 1]
                : dt.deposits[msg.sender];
        }
        uint256 cantidadARetirar = index == 0 ? dt.deposits[msg.sender] : min;
        //cantidad ARetirar debe ser menor
        require(cantidadARetirar <= dt.valorDAORecibido);
        dt.deposits[msg.sender] -= cantidadARetirar;
        if (cantidadARetirar > 0)
            payable(msg.sender).transfer(cantidadARetirar);
    }
}
