//
//  StarScoreView.swift
//  JSDStarScoreView
//
//  Created by 姜守栋 on 2018/4/17.
//  Copyright © 2018年 Nick.Inc. All rights reserved.
//

import UIKit

fileprivate let defaultNumberOfStar = 5
fileprivate let foregroudStarImageName = "icon_rate_selected"
fileprivate let backgroudStarImageName = "icon_rate_unselected"

protocol StarScoreViewDelegate: NSObjectProtocol {
    
    func starScoreView(starView: StarScoreView, didChanged newScore: CGFloat)
    
}

final class StarScoreView: UIView {

    /// 得分，范围是0-1,默认是1
    var score: CGFloat = 0.0 {
        didSet {
            if score < 0 {
                score = 0.0
            } else if (score > 1) {
                score = 1.0
            }
            delegate?.starScoreView(starView: self, didChanged: score)
            setNeedsLayout()
        }
    }
    weak var delegate: StarScoreViewDelegate?
    /// 只显示分数，是否允许交互进行打分, 默认是false
    var isOnlyDispalyScore: Bool = false {
        
        didSet {
            isUserInteractionEnabled = !isOnlyDispalyScore
        }
        
    }
    
    // 星星的个数
    private var numberOfStar: Int = 0
    private var foregroundStarView: UIView?
    private var backgroundStarView: UIView?
    private var panOffset: CGFloat = 0.0
    
    init(frame: CGRect, numberOfStar: Int) {
        super.init(frame: frame)
        self.numberOfStar = numberOfStar
        config()
    }
    
    override convenience init(frame: CGRect) {
        self.init(frame: frame, numberOfStar: defaultNumberOfStar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.numberOfStar = defaultNumberOfStar
        config()
    }
    
    private func config() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userTapScore))
        tapGesture.numberOfTapsRequired = 1;
        self.addGestureRecognizer(tapGesture)
        
        let panGeture = UIPanGestureRecognizer(target: self, action: #selector(userPanScore))
        self.addGestureRecognizer(panGeture)
        
    }
    
    @objc
    private func userTapScore(tap: UITapGestureRecognizer) {
        
        let tapPoint = tap.location(in: self)
        panOffset = tapPoint.x
        let realStarScore = panOffset / (bounds.size.width / CGFloat(numberOfStar))
        self.score = getCompleteOrHalfScore(score: Double(realStarScore))
        
    }
    
    @objc
    private func userPanScore(pan: UIPanGestureRecognizer) {
        
        if panOffset > bounds.size.width || panOffset < 0 {
            return
        }
        
        let translation = pan.translation(in: self)
        pan.setTranslation(CGPoint.zero, in: self)
        
        switch pan.state {
        case .began, .changed:
            if translation.x + panOffset > bounds.size.width {
                panOffset = bounds.size.width
            } else if (translation.x + panOffset < 0) {
                panOffset = 0
            } else {
                panOffset = panOffset + translation.x
            }
            let realStarScore = panOffset / (bounds.size.width / CGFloat(numberOfStar))
            self.score = getCompleteOrHalfScore(score: Double(realStarScore))
            
        case .ended:
            let realStarScore = panOffset / (bounds.size.width / CGFloat(numberOfStar))
            self.score = getCompleteOrHalfScore(score: Double(realStarScore))
        default:
            break
        }
        
        
    }

    
    private func getCompleteOrHalfScore(score: Double) -> CGFloat {
        
        var result = 0.0
        
        let decimal = score - floor(score)
        if decimal > 0.5 {
            result = ceil(score)
        } else if decimal == 0 {
            result = floor(score)
        } else {
            result = floor(score) + 0.5
        }
        return CGFloat(result / Double(numberOfStar))
        
    }
    
    private func creatStarView(with imageName: String) -> UIView? {
        
        let view = UIView(frame: bounds)
        view.clipsToBounds = true
        view.backgroundColor = .clear
        for i in 0..<numberOfStar {
            let i = CGFloat(i)
            let num = CGFloat(numberOfStar)
            guard let image = UIImage(named: imageName) else {
                assert(false, "加载图片出现错误！")
                return nil
            }
            let containerView = UIView()
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            containerView.frame = CGRect(x: i*bounds.size.width / num,
                                         y: 0,
                                         width: bounds.size.width / num,
                                         height: bounds.size.height)
            imageView.center = CGPoint(x: containerView.bounds.size.width / 2.0,
                                       y: containerView.bounds.size.height / 2.0)
            imageView.bounds = CGRect(x: 0.0,
                                      y: 0.0,
                                      width: image.size.width,
                                      height: image.size.height)
            containerView.addSubview(imageView)
            view.addSubview(containerView)
        }
        
        return view
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if foregroundStarView == nil {
            backgroundStarView = creatStarView(with: backgroudStarImageName)
            foregroundStarView = creatStarView(with: foregroudStarImageName)
            
            self.addSubview(backgroundStarView!)
            self.addSubview(foregroundStarView!)
        }
        
        UIView.animate(withDuration: 0.0) {
            self.foregroundStarView?.frame = CGRect(x: 0.0,
                                               y: 0.0,
                                               width: self.bounds.size.width * self.score,
                                               height: self.bounds.size.height)
        }
    }
     
}
