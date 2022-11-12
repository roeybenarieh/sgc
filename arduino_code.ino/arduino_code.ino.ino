#include <MsTimer2.h> // this library needs to be installed from the arduino library manager in the IDE
#include <SoftwareSerial.h>
//Dock: https://docs.arduino.cc/learn/built-in-libraries/software-serial#write

//#constants:
#define confirm_message 101
#define wakeup_phone    11
#define press_ok        "0"
#define press_up        "1"
#define press_down      "3"
#define turn_device_on  "2"

//pins:
SoftwareSerial HM10(4, 3); // Pins: RX = 4 (Purple wire), TX = 3 (Gray wire)
#define  wakeup_pin 2
#define  up         13
#define  ok         8
#define  down       7

void setup() {

  pinMode(wakeup_pin, OUTPUT);            //declare the pin as output (responsible for waking up the device)
  pinMode(up, OUTPUT);                    //declare the pin as output  (responsible for UP button and the arduino Uno onboard Led that is marked as 'L')
  pinMode(ok, OUTPUT);                    //declare the pin as output (responsible for Ok button)
  pinMode(down, OUTPUT);                  //declare the pin as output (responsible for DOWN button)
  
  //determining the beginning state of all of the outputs:
  digitalWrite (wakeup_pin, LOW);
  digitalWrite (up, LOW);
  digitalWrite (ok, LOW);
  digitalWrite (down, LOW);
  
  //initialise the serial for the usb
  Serial.begin(9600);                     //initialise serial COM at 9600 baudrate
  Serial.println("HM10 serial started at 9600");
  Serial.println("you can disconnect the usb cable from the Arduino and you are all set up :-)");
  Serial.end();

  //initialise the serial for the Bluetooth module
  HM10.begin(9600); // Sets HM10 the speed (baud rate) for the serial communication 
  HM10.setTimeout(2000); // 2 seconds until serial stop looking for the continuation of the data
  HM10.listen();  // listen the HM10 port

  //every 5 minutes send bluetooth message for the iphone so he could wake up and run its own code
  MsTimer2::set(5 * 60000, remind_phone_to_work); // 5s period, send one bit
  MsTimer2::start();
}
void remind_phone_to_work(){
  HM10.write(wakeup_phone); // send two bits with 1's in both of them
}

void loop() {
  // Enable SoftwareSerial object to listen
  //HM10.listen();  // listen the HM10 port
  
  //Get the number of bytes (characters) available for reading from a software serial port. This is data that has already arrived and stored in the serial receive buffer.
  while (HM10.available() > 0) {   // if HM10 sends something then read
    //Return a character that was received on the RX pin of the SoftwareSerial object.
    String data = HM10.readString(); //Serial.readStringUntil('a character that will make the string to stop')
    if(data.startsWith("in")){//injection format
      inject(data.substring(2,data.length()).toInt());
      HM10.write(confirm_message);
    }
    else{
      if (data == press_up) {//press up
        push_button_up();
      }
      else if (data == press_ok) {//press ok
        push_button_ok();
      }
      else if (data == turn_device_on) {//Turn on the device
        wakeup_pin_device();
      }
      else if (data == press_down){
        push_button_down();
      }
    }
    HM10.flush();
  }
}
void inject(int amount){
  if (amount <= 50){
    wakeup_pin_device();
    delay(15000);//assuming there is low buttery alert(which takes screen time)
    push_button_ok(); delay(500); push_button_ok();
    delay(15000); //wait for the device to connect to the insulin pump
    for(int i = 0; i < amount; i++){
      push_button_up();
      delay(500);
    }
    push_button_ok(); delay(500); push_button_ok();
    delay(15000); //wait for the device to connect to the insulin pump 
    push_button_ok(); //come back to the main menu
    delay(500);
    wakeup_pin_device();
  }
}

void push_button_up(){
  push_button(up, 200);
}

void push_button_ok(){
  push_button(ok, 200);
}
void push_button_down(){
  push_button(down, 200);
}

void wakeup_pin_device(){
  push_button(wakeup_pin, 7000);
}
//press-time is how much time the button is pressed in seconds!!
void push_button(int pin, int mil_presstime){ // 1000 milsec = 1 sec
  digitalWrite (pin, HIGH);
  delay(mil_presstime);
  digitalWrite (pin, LOW);
}