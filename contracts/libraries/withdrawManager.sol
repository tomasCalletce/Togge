// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "../Data.sol";
import "../InterestRateModel.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

library WithdrawManager {
    //@Borrower -- withdraw loan and create lp token
    function acceptLoanWithdrawLoan(
        string memory _name,
        string memory _symbol,
        Data storage dt //require dao
    ) external {
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
        //REVISAR PARA INCLUIR DECIMALES
        dt.deudaTotal = (dt.ethSupplied * (1e18 + dt.interesTotal)) / 1e18;

        //se calcula el total a pagar de el DAO
        dt.deudaActual = dt.deudaTotal;
        //DAO has accepted
        dt.endBorrowerAcceptWindow = block.timestamp;
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
    function withdrawLPtoken(Data storage dt) external returns (bool) {
        require(dt.loanAccepted, "TOGGE: LOAN_NOT_ACCEPTED");
        require(dt.deposits[msg.sender] != 0, "TOGGE: NO_VALUE");
        require(!dt.nftClaimed[msg.sender], "TOGGE: ClAIMED");

        dt.nftClaimed[msg.sender] = true;
        dt.LPnfts.mint(msg.sender, dt.nftCounter, dt.deposits[msg.sender]);

        if (dt.accum.length != 0) {
            uint256 temp = dt.accum[dt.currentIndex++] +
                dt.deposits[msg.sender];
            dt.accum.push(temp);
        } else {
            dt.accum.push(dt.deposits[msg.sender]);
        }
        dt.indexing[dt.nftCounter] = dt.currentIndex;
        dt.nftCounter++;
    }

    // @LP - withdraw deposit + interest
    function withdraw(Data storage dt, uint256 _id) external {
        uint256 _valorDAORecibido = dt.deudaTotal - dt.deudaActual;
        uint256 _deposit = dt.LPnfts.deposits(_id);
        uint256 index = dt.indexing[_id];
        bool primero = index == 0 && dt.accum[index] <= _valorDAORecibido;
        bool segundo = true;
        uint256 yaSaco = 0;
        if (index > 0) {
            segundo = dt.accum[index - 1] < _valorDAORecibido; //
            yaSaco = dt.accum[index] - dt.accum[index - 1] - _deposit;
        }
        require(segundo || primero, "not eligible");
        require(_deposit > 0, "insufficient Funds");
        uint256 min = 0;

        if (index > 0) {
            require(
                dt.accum[index - 1] + yaSaco < _valorDAORecibido,
                "can't withdraw more"
            );
            min = _valorDAORecibido - dt.accum[index - 1] < _deposit
                ? _valorDAORecibido - dt.accum[index - 1]
                : _deposit;
        }
        uint256 cantidadARetirar = index == 0 ? _deposit : min;
        //cantidad ARetirar debe ser menor
        require(cantidadARetirar <= _valorDAORecibido);
        if (cantidadARetirar > 0) {
            dt.LPnfts.withdraw(_id, cantidadARetirar);
            payable(msg.sender).transfer(cantidadARetirar);
        }
    }

    function withdrawDaoTokens(Data storage dt) external {
        require(dt.deudaActual == 0 && dt.loanAccepted);
        bool success = ERC20(dt.borrowerToken).transfer(
            payable(dt.borrower),
            dt.numberBorrowerTokens
        );
        require(success, "TOGGE::withdrawDaoTokens | transfer failed");
    }
}
