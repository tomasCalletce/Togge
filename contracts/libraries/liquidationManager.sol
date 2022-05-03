// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "../Data.sol";

library LiquidationManager {
    // function liquidate();
    function liquidate(Data storage dt) external {
        uint256 _currentTime = block.timestamp;
        uint256 ciclosPasados = 0;
        if ((_currentTime - dt.ultimoPago) >= dt.duracionCiclo) {
            ciclosPasados = (_currentTime - dt.ultimoPago) / dt.duracionCiclo;
        }
        uint256 pagoCiclo = dt.deudaTotal / dt.numCiclos;
        uint256 cantidadAPagar = pagoCiclo * ciclosPasados;
        if (dt.deudaTotal - dt.deudaActual < cantidadAPagar) {
            cantidadAPagar = 0;
            //no hay pagado suficiente
            //llamar dutchAuction
        }
    }
}
