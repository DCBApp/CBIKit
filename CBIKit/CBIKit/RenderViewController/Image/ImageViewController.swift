//
//  ImageViewController.swift
//  CBIKit
//
//  Created by Quinn on 2019/9/30.
//  Copyright © 2019 Quinn. All rights reserved.
//

import UIKit
import MetalKit

class ImageViewController: UIViewController {
    var imageView:CBIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = CBIImageView(frame: view.bounds, image: UIImage(named: "girls"))
        self.imageView = imageView
        view.addSubview(imageView)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        imageView?.image = UIImage(named: "mygirls.jpg")
    }
}
