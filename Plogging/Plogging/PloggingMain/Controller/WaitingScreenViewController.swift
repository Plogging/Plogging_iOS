//
//  WaitingScreenViewController.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/22.
//

import UIKit

class WaitingScreenViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    private var timer: Timer?
    private var second: Int = 3 {
        didSet {
            imageView.image = UIImage(named: "\(second)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        createTimer()
    }
    
    private func createTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(changeSecond), userInfo: nil, repeats: true)
    }
     
    @objc private func changeSecond(){
        second = second - 1
        
        if second == 0 {
            timer?.invalidate()
            moveToPloggingRunningView()
        }
    }
    
    private func moveToPloggingView() {
        let storyboard = UIStoryboard(name: "Plogging", bundle: nil)
        if let ploggingMainViewController = storyboard.instantiateViewController(withIdentifier: "PloggingMainViewController") as? PloggingMainViewController {
            self.dismiss(animated: false, completion: {
                ploggingMainViewController.modalPresentationStyle = .fullScreen
                self.rootViewController?.present(ploggingMainViewController, animated: false, completion: nil)
            })
        }
    }
}
