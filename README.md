# sgc
app for managing remote insulin injection
currently the whole app is based on a phone that communicate to arduino board via bluetooth module.
the arduino board is connected to a "contour plus" glucometer that can remotly inject insulin in metronic insulin pumps.
the app gets CGM values according to pydexcom project.(only works with dexcom sensors)

things to do:
1) make the app work in the background even when it is not connected to power
2) create better function for evaluating the injection sugestion

