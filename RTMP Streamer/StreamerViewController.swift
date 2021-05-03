//
//  StreamingViewController.swift
//  YouStreamer
//
//  Created by Alexander Kozhevin on 07/08/2019.
//  Copyright © 2019 Alexander Kozhevin. All rights reserved.
//

import UIKit
import LFLiveKit
import QuartzCore

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}


class StreamerViewController: UIViewController, LFLiveSessionDelegate {
    
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscapeRight
        } else {
            return .all
        }
    }
    
    
    //    override var shouldAutorotate: Bool {
    //        return false
    //    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
     
        
//        let value = UIInterfaceOrientation.landscapeLeft.rawValue
//        UIDevice.current.setValue(value, forKey: "orientation")
//
        
        self.session.delegate = self
        self.session.preView = self.view
        
        self.requestAccessForVideo()
        self.requestAccessForAudio()
        self.view.backgroundColor = UIColor.clear
        self.view.addSubview(containerView)
        containerView.addSubview(stateLabel)
        containerView.addSubview(closeButton)
        //containerView.addSubview(beautyButton)
        containerView.addSubview(cameraButton)
        containerView.addSubview(self.startLiveButton)
        
        
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                    // Excecute after 3 seconds
//
//
//
//
//
//                }
        
        cameraButton.addTarget(self, action: #selector(didTappedCameraButton(_:)), for:.touchUpInside)
        //beautyButton.addTarget(self, action: #selector(didTappedBeautyButton(_:)), for: .touchUpInside)
        startLiveButton.addTarget(self, action: #selector(didTappedStartLiveButton(_:)), for: .touchUpInside)
        
        closeButton.addTarget(self, action: #selector(didTappedCloseButton(_:)), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: AccessAuth
    
    func requestAccessForVideo() -> Void {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video);
        switch status  {
        //Лицензионный диалог не появился, инициируйте лицензию
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                if(granted){
                    DispatchQueue.main.async {
                        self.session.running = true
                    }
                }
            })
            break;
        // Авторизация активирована и может продолжаться
        case AVAuthorizationStatus.authorized:
            session.running = true;
            break;
        // Пользователь явно отказывает в авторизации или камера не может получить доступ
        case AVAuthorizationStatus.denied: break
        case AVAuthorizationStatus.restricted:break;
        default:
            break;
        }
    }
    
    func requestAccessForAudio() -> Void {
        let status = AVCaptureDevice.authorizationStatus(for:AVMediaType.audio)
        switch status  {
            //Лицензионный диалог не появился, инициируйте лицензию
            
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: { (granted) in
                
            })
            break;
        // Авторизация активирована и может продолжаться
        case AVAuthorizationStatus.authorized:
            break;
            // Пользователь явно отказывает в авторизации или камера не может получить доступ
            
        case AVAuthorizationStatus.denied: break
        case AVAuthorizationStatus.restricted:break;
        default:
            break;
        }
    }
    
    //MARK: - Callbacks
    
    // Обратный звонок
    
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        print("debugInfo: \(debugInfo?.currentBandwidth)")
    }
    
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        print("errorCode: \(errorCode.rawValue)")
    }
    
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        print("liveStateDidChange: \(state.rawValue)")
        switch state {
        case LFLiveState.ready:
            stateLabel.text = "Offline"
            let color2 = hexStringToUIColor(hex: "#303952")
            stateLabel.backgroundColor = color2
            break;
        case LFLiveState.pending:
            stateLabel.text = "Connecting"
            break;
        case LFLiveState.start:
            stateLabel.text = "Online"
            let color2 = hexStringToUIColor(hex: "#e15f41")
            stateLabel.backgroundColor = color2
            break;
        case LFLiveState.error:
            stateLabel.text = "Connection error"
            break;
        case LFLiveState.stop:
            stateLabel.text = "Offline"
            let color2 = hexStringToUIColor(hex: "#303952")
            stateLabel.backgroundColor = color2
            break;
        default:
            break;
        }
    }
    
    //MARK: - Events
    
    // Начать жить
    @objc func didTappedStartLiveButton(_ button: UIButton) -> Void {
        startLiveButton.isSelected = !startLiveButton.isSelected;
        if (startLiveButton.isSelected) {
            startLiveButton.setTitle("Finish stream", for: UIControl.State())
            let stream = LFLiveStreamInfo()
            
            //let nameurl = "rtmp://push.youstreamer.com/in/4944?d07c7ebfc829d7335a1adc617b082733"
            let nameurl = StorageGet(key: "push_url") as String
            stream.url = nameurl
            session.startLive(stream)
        } else {
            startLiveButton.setTitle("Start streaming", for: UIControl.State())
            session.stopLive()
        }
    }
    
    // красота
    
    @objc func didTappedBeautyButton(_ button: UIButton) -> Void {
        session.beautyFace = !session.beautyFace;
        beautyButton.isSelected = !session.beautyFace
    }
    
    // камера
    @objc func didTappedCameraButton(_ button: UIButton) -> Void {
        let devicePositon = session.captureDevicePosition;
        session.captureDevicePosition = (devicePositon == AVCaptureDevice.Position.back) ? AVCaptureDevice.Position.front : AVCaptureDevice.Position.back;
    }
    
    // близко
    
    @objc func didTappedCloseButton(_ button: UIButton) -> Void  {
        print("pizda vagina")
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "mainpage") as? UIViewController
        //            testboard
        //            streamingscreen
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
        
        
    }
    
    //MARK: - Getters and Setters
    
    //  Разрешение по умолчанию 368 ＊ 640  аудиочастота：44.1 iphone6 выше 48  Двухканальный вертикальны экран
    var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.defaultConfiguration(for: LFLiveAudioQuality.high)
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: LFLiveVideoQuality.high3)
        
        
        videoConfiguration?.videoSizeRespectingAspectRatio = true
        videoConfiguration?.autorotate = true
        
        videoConfiguration?.outputImageOrientation = UIInterfaceOrientation.landscapeRight
        
        
        
        
        
        
        // let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: LFLiveVideoQuality.Low3)
        
        //let videoConfiguration = LFLiveVideoConfiguration.defaultConfigurationForQuality(LFLiveVideoQuality.LFLiveVideoQuality.high3)
        
        //videoConfiguration?.landscape = true
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
        //session?.warterMarkView = self.overlayView
        //let customView = MyCustomView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        
        let screenSize: CGRect = UIScreen.main.bounds
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        
        //myView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let imageName = "logo.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        myView.addSubview(imageView)
        //Imageview on Top of View
        myView.bringSubviewToFront(imageView)
        
        
        //session?.warterMarkView = myView
        
        return session!
    }()
    
    // вид
    var containerView: UIView = {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        containerView.backgroundColor = UIColor.clear
        containerView.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleHeight]
        return containerView
    }()
    
    // состояние
    var stateLabel: UILabel = {
        let stateLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 180, height: 40))
        stateLabel.text = "Offline"
        stateLabel.textColor = UIColor.white
        stateLabel.font = UIFont.systemFont(ofSize: 14)
        let color2 = hexStringToUIColor(hex: "#303952")

        stateLabel.backgroundColor = color2
        stateLabel.textAlignment = .center
        stateLabel.layer.cornerRadius = 20
        stateLabel.layer.masksToBounds = true
        return stateLabel
    }()
    
    // Кнопка закрытия
    var closeButton: UIButton = {
        let closeButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 10 - 44, y: 20, width: 44, height: 44))
        closeButton.setImage(UIImage(named: "my"), for: UIControl.State())
        let color2 = hexStringToUIColor(hex: "#303952")
        
        closeButton.layer.cornerRadius = 20
        closeButton.layer.masksToBounds = true
        closeButton.backgroundColor = color2
        return closeButton
    }()
    
    // камера
    var cameraButton: UIButton = {
        let cameraButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 54 * 2, y: 20, width: 44, height: 44))
        cameraButton.setImage(UIImage(named: "camra_preview"), for: UIControl.State())
        let color2 = hexStringToUIColor(hex: "#303952")
        cameraButton.backgroundColor = color2
        cameraButton.layer.cornerRadius = 20
        cameraButton.layer.masksToBounds = true
        return cameraButton
    }()
    
    // камера
    var beautyButton: UIButton = {
        
        
        var height = UIScreen.main.bounds.height
        var width = UIScreen.main.bounds.width
        
        if (width < height){
            height = UIScreen.main.bounds.width
            width = UIScreen.main.bounds.height
        }
        
        let beautyButton = UIButton(frame: CGRect(x: width - 54 * 3, y: 20, width: 44, height: 44))
        beautyButton.setImage(UIImage(named: "camra_beauty"), for: UIControl.State.selected)
        beautyButton.setImage(UIImage(named: "camra_beauty_close"), for: UIControl.State())
        return beautyButton
    }()
    
    // Кнопка запуска в реальном времени
    
    
    
    var startLiveButton: UIButton = {
        
        var height = UIScreen.main.bounds.height
        var width = UIScreen.main.bounds.width
        
        if (width < height){
            height = UIScreen.main.bounds.width
            width = UIScreen.main.bounds.height
        }
        
        let startLiveButton = UIButton(frame: CGRect(x: 30, y: height - 75, width: width - 10 - 44, height: 44))
        startLiveButton.layer.cornerRadius = 22
        startLiveButton.setTitleColor(UIColor.white, for:UIControl.State())
        startLiveButton.setTitle("Start stream", for: UIControl.State())
        startLiveButton.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        let color2 = hexStringToUIColor(hex: "#303952")
        startLiveButton.backgroundColor = color2
        return startLiveButton
    }()
    
    
    
}
