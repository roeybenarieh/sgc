//
//  InjectViewController.swift
//  sgc
//
//  Created by roey ben arieh on 07/08/2022.
//

import UIKit
import AudioToolbox

class InjectVC: UIViewController {
    
    //MARK: IBOutlet variable
    
    @IBOutlet weak var Status: UILabel!
    
    @IBOutlet weak var InjectionAmount: UILabel!
    //MARK: UIView
    
    var circle: UIImageView! = nil
    
    //MARK: variable
    
    ///if in the middle of injection
    var busy: Bool = false
    
    ///represent the amount of inuslin the user want to inject
    private var amount: Int{
        get{
            return amountInt
        }
        set(newAmount){
            if !busy{
                ///changing the Int representation of amount
                amountInt = newAmount
                ///changing the String representation of amount
                InjectionAmount.text = injectionIntegetToString(amount:amountInt)
            }
        }
    }
    private var amountInt: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        //initializing the circle
        circle = UIImageView(frame: CGRect(x: view.center.x, y: view.center.y, width: 1, height: 1))
        circle.backgroundColor = UIColor.systemMint
        circle.layer.cornerRadius = circle.frame.size.width/2
        // get notifiction when a injection has confirmed
        NotificationCenter.default.addObserver(self, selector: #selector(injectionConfirmed(notification:)), name: NSNotification.Name.init(rawValue: "InjectionConfirmation"), object: nil)
    }
    
    
    //MARK: IBActions
    
    
    @IBAction func presetOne(_ sender: Any) {
        amount = 10
    }
    
    @IBAction func presetTwo(_ sender: Any) {
        amount = 20
    }
    
    @IBAction func presetThree(_ sender: Any) {
        amount = 30
    }
    
    //the -/+ buttons
    
    @IBAction func ClickMinus(_ sender: Any) {
        if amount > 0{
            amount -= 1
        }
    }
    
    @IBAction func ClickPlus(_ sender: Any) {
        if amount < 50{
            amount += 1
        }
    }
    
    //injection button
    @IBAction func Inject(_ sender: Any) {
        if !busy && amount > 0{
            busy = true
            changeStatus(status: InjectionAmount.text! + " injection in progress")
            Bhelper.sendInjection(amount: amount)
            sentInjectionIndicator()
        }
        else{// can't inject yet - making a vibration
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
        }
    }
    
    //MARK: functions
    //change the status label
    func changeStatus(status:String){
        self.Status.text = "Status: "+status
    }
    
    // injection message got confirmed
    @objc func injectionConfirmed(notification:NSNotification){
        //ignore the message, it has to be confirmation beacuse that's the only message type the arduino can send
        succesfulInjectionIndicator()
        //change the status
        self.Status.textColor = UIColor.systemRed
        changeStatus(status: "injected " + InjectionAmount.text! + " succesfuly!")
        
        //return to the beggining
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { //wait 3 seconds
            self.Status.textColor = UIColor.systemBlue
            self.changeStatus(status: "waiting for command")
            self.busy = false
        }
    }
    //indicate the user he touched the injec button
    func sentInjectionIndicator(){
        view.insertSubview(circle, belowSubview: Status)
        UIView.animate(withDuration: 5, delay: 0, options: [], animations: {
            let maxstretch = max(self.view.frame.size.height, self.view.frame.size.width) * 6
            self.circle.transform = CGAffineTransform(scaleX: maxstretch, y: maxstretch)
        })
    }
    func succesfulInjectionIndicator(){
        UIView.animate(withDuration: 5, delay: 0, options: [], animations: {
            self.circle.transform = CGAffineTransform.identity
        }) { finished in
            self.circle.removeFromSuperview()
        }
    }
}
func injectionIntegetToString(amount:Int!) -> String{
    if amount == nil{
        return "??"
    }
    var amountStr = String(amount)
    if amount < 10{
        amountStr = "0." + amountStr
    }
    else{
        amountStr.insert(".", at: amountStr.index(before: amountStr.endIndex))
    }
    return amountStr
}
