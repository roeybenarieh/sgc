#include <SoftwareSerial.h>
//Dock: https://docs.arduino.cc/learn/built-in-libraries/software-serial#write

//#constants:
#define confirm_message 'C'
#define press_ok        "0"
#define press_up        "1"
#define turn_device_on  "2"

//pins:
SoftwareSerial HM10(2, 3); // Pins: RX = 2, TX = 3
#define  LED        13
#define  wakeup_pin 10
#define  up         11
#define  ok         12

void setup() {

  pinMode(LED, OUTPUT);                   //declare the LED pin (13) as output
  pinMode(wakeup_pin, OUTPUT);            //declare the pin (10) as output (responsible for waking up the device)
  pinMode(up, OUTPUT);                    //declare the pin(11) as output  (responsible for UP button)
  pinMode(ok, OUTPUT);                    //declare the pin (12) as output (responsible for Ok button)
  
  //determening the beggining state of all of the outputs:
  digitalWrite (LED, LOW);
  digitalWrite (wakeup_pin, LOW);
  digitalWrite (up, LOW);
  digitalWrite (ok, LOW);
  
  //initialize the serial for the usb
  Serial.begin(9600);                     //initialize serial COM at 9600 baudrate
  Serial.println("HM10 serial started at 9600");
  Serial.println("you can disconnect the usb cable from the arduino and you are all set up :-)");
  //Serial.end();//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  //initialize the serial for the Bluetooth module
  HM10.begin(9600); // Sets HM10 the speed (baud rate) for the serial communication 
  HM10.setTimeout(2000); // 2 seconds until serial stop looking for the continuation of the data
  HM10.listen();  // listen the HM10 port
}

void loop() {
  // Enable SoftwareSerial object to listen
  //HM10.listen();  // listen the HM10 port
  
  //Get the number of bytes (characters) available for reading from a software serial port. This is data that has already arrived and stored in the serial receive buffer.
  while (HM10.available() > 0) {   // if HM10 sends something then read
    //Return a character that was received on the RX pin of the SoftwareSerial objecto.
    String data = HM10.readString(); //Serial.readStringUntil('a character that will make the string to stop')
    Serial.println(data);
    HM10.write(confirm_message);
    digitalWrite (LED, HIGH);
  
    if (data == press_up) {//press up
      push_button_up();
    }
    else if (data == press_ok) {//press ok
      push_button_ok();
    }
    else if (data == turn_device_on) {//Turn on the device
      wakeup_pin_device();
    }
    digitalWrite(LED, LOW);
    HM10.flush();
  }
}
void push_button_up(){
  push_button(up, 200);
}

void push_button_ok(){
  push_button(ok, 200);
}

void wakeup_pin_device(){
  push_button(wakeup_pin, 7000);
}
//presstime is how much time the button is pressed in seconds!!
void push_button(int pin, int mil_presstime){
  digitalWrite (pin, HIGH);
  delay(mil_presstime);
  digitalWrite (pin, LOW);
}
