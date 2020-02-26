import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Scanner;
import java.io.PrintWriter;

import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.SwingConstants;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.JFreeChart;
import org.jfree.data.xy.XYSeries;
import org.jfree.data.xy.XYSeriesCollection;

import com.fazecast.jSerialComm.SerialPort;

public class SensorGraph {
	
	static SerialPort chosenPort;
	static int x = 0;

	public static void main(String[] args) {
		
		//Configuración de Ventana
		JFrame window = new JFrame();
		window.setTitle("LEGO Robot ARM");
		window.setSize(680, 400);
		window.setLayout(new BorderLayout());
		window.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		
		//Interfaz para la selección de puertos
		JComboBox<String> portList = new JComboBox<String>();
		JButton connectButton = new JButton("Disconnected");
		connectButton.setBackground(Color.ORANGE);
		JPanel topPanel = new JPanel();
		topPanel.setBackground(Color.WHITE);
		topPanel.add(portList);
		topPanel.add(connectButton);
		window.add(topPanel, BorderLayout.NORTH);
		
		//Obtener los puertos seriales disponibles
		SerialPort[] portNames = SerialPort.getCommPorts();
		for(int i = 0; i < portNames.length; i++)
			portList.addItem(portNames[i].getSystemPortName());
				
		//Generar la gráfica de temperatura
		XYSeries series = new XYSeries("Sensor 1");	//Serie para almacenar los datos de temperatura
		XYSeriesCollection dataset = new XYSeriesCollection(series);
		JFreeChart chart = ChartFactory.createXYLineChart("ADC Voltage Readings", "Time (x2000 miliseconds)", "ADC Voltage Readings", dataset);	//Chart Factory es la clase para generar la gráfica

		window.add(new ChartPanel(chart), BorderLayout.CENTER);
						
		//Configuración del botón de conexión
		connectButton.addActionListener(new ActionListener(){
			@Override public void actionPerformed(ActionEvent arg0) {
				if(connectButton.getText().equals("Disconnected")) {
					//Se intenta realizar la conexión al puerto serial seleccionado
					chosenPort = SerialPort.getCommPort(portList.getSelectedItem().toString());	//Obtener el puerto seleccionado por el usuario
					chosenPort.setComPortTimeouts(SerialPort.TIMEOUT_SCANNER, 0, 0);	//Wait for string on the port
					if(chosenPort.openPort()) {
						connectButton.setBackground(Color.GREEN);
						connectButton.setText("Connected");	//Cambiar texto del botón
						portList.setEnabled(false);	//Deshabilitar la selección de puertos
					}
					
					//Se utiliza otro hilo para escuchar el puerto serial y obtener los datos
					Thread thread = new Thread(){
						@Override public void run() {
							//Scanner conectado al puerto serial para obtener los datos
							Scanner scanner = new Scanner(chosenPort.getInputStream());
							while(scanner.hasNextLine()) {
								//Se requiere utilizar un metodo try catch para evitar que el programa se bloquee si no recibe la transmision desde el inicio
								try {
									String line = scanner.nextLine();
									int number = (int) line.charAt(0);
									System.out.print(line);
									System.out.println(number);
									series.add(x++, number);
									window.repaint();
								} catch(Exception e) {}
							}
							scanner.close();
						}
					};
					thread.start();
				} else {
					//Desconectar el programa del puerto serial
					chosenPort.closePort();
					connectButton.setBackground(Color.ORANGE);
					portList.setEnabled(true);	//Rehabilitar la lista de puertos
					connectButton.setText("Disconnected");	//Cambiar texto del botón
					series.clear();	//eliminar los datos obtenidos para resetear el monitoreo
					x = 0;
				}
			}
		});
		
		//Mostrar la ventana
		window.setVisible(true);
	}
}