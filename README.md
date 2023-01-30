# sgc
app for managing remote insulin injection

in addition, it can inject remotly automaticly when blood sugar is to high

## Hardware requirements
* iphone - the app is writen in swift.
* Internet connection - the app uses API to access glucose checks(CGM)
* mac computer - the only way(*maybe there is another way I am not familiar with) to upload the app to the iphone is threw macos application calles xcode.
* dexcom sensor - the app fetch cgm data only from dexcom's servers.
* 'contour plus' glucometer - this glucometer can remotly inject to Medtronic insulin pump. (only work with some Medtronic pumps)
* arduino + optocoupler = these are hardware components that allow as to controll the glucometer just like it was a human operating it.
* bluetooth low energy module = this module connectes to the arduino and allow as to send remote commands to the arduino from the iphone app.

## building the arduino
--

## Automaic Injections info
if you want to use automatic injections there are a few thing to consider:
* iphone cant be at low power mode, otherwise the automatic injections whouldn't work
* you need to know basic swift code because you MUST change the file `injector.swift` to your needs, this is where the injection amount calculation is made.


### things to do
1) create better function for evaluating the injection sugestion
2) store all app settings in a database
3) create the settings screen
