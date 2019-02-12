//
//  PhotoViewController.swift
//  multiple_windows
//
//  Created by Masoud Sasha on 2/12/19.
//  Copyright © 2019 Masoud Sasha. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoViewController: UIViewController {

    var takenPhoto:UIImage?
    
    @IBOutlet weak var ImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let availbleImage = takenPhoto{
            ImageView.image = availbleImage
        }
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
