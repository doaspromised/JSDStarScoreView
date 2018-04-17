//
//  ViewController.swift
//  JSDStarScoreView
//
//  Created by 姜守栋 on 2018/4/17.
//  Copyright © 2018年 Nick.Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, StarScoreViewDelegate {
    
    func starScoreView(starView: StarScoreView, didChanged newScore: CGFloat) {
        print(newScore)
    }
    

    @IBOutlet weak var starView: StarScoreView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        starView.score = 0
        starView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

