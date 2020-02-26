# FPGA-LEGO-robot-Arm
El presente proyecto consiste en el desarrollo de un sistema de control lógico para un robot manipulador de 4 ejes que permita manipular cada uno de forma independiente. El controlador propuesto es implementado en una **FPGA Altera Cyclone V 5CSEMA5F31C6** integrado en la tarjeta **DE1-SOC** de Terasic junto con una tarjeta diseñada para la lectura de las señales de entrada y control de las señales de potencia para los motores, se utilizan optoaisladores para la separación de la tierra de potencia y tierra lógica.
La implementación del código en VHDL permite la jerarquización de bloques de código que cumplan cada una de las funciones UART, PWM, multiplexor, control de motores, etc. requeridos por el proyecto.

El sistema desarrollo consiste en una tarjeta de interfaz para la FPGA y un panel de control para el operador.
![Proyecto](https://github.com/LuisErnie/FPGA-LEGO-robot-Arm/blob/master/Anexo%20C.%20Memoria%20Fotogr%C3%A1fica/Panel%20de%20Control.jpg)

El manipulador fue construido con un Kit de LEGO Mindstorms NXT con 4 grados de libertad cada uno controlado por una implementación independiente en la FPGA, esto para demostrar las ventajas de implementar controladores multieje en una FPGA
![Robot](https://github.com/LuisErnie/FPGA-LEGO-robot-Arm/blob/master/Anexo%20C.%20Memoria%20Fotogr%C3%A1fica/Robot%20Manipulador.jpg)
