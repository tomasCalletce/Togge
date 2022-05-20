// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "../Data.sol";
import "../DutchAuction.sol";
import "hardhat/console.sol";

library LiquidationManager {
    // function liquidate();
    function liquidate(Data storage dt) external returns (bool) {
        uint256 _currentTime = block.timestamp;
        uint256 ciclosPasados = 0;
        console.log("corre");
        if ((_currentTime - dt.ultimoPago) >= dt.duracionCiclo) {
            ciclosPasados = (_currentTime - dt.ultimoPago) / dt.duracionCiclo;
        }
        console.log("time");
        console.log(_currentTime);
        uint256 pagoCiclo = dt.deudaTotal / dt.numCiclos;
        uint256 cantidadAPagar = pagoCiclo * ciclosPasados;
        console.log("szs");
        return (dt.deudaTotal - dt.deudaActual < cantidadAPagar);
    }
}
