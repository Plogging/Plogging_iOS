//
//  OnboardingCustomPageControl.swift
//  Plogging
//
//  Created by 김혜리 on 2021/02/04.
//

import UIKit

class OnboardingCustomPageControl: UIPageControl {

    @IBInspectable let currentPageImage: UIImage? = UIImage(named: "onboardingSelected")
    @IBInspectable let otherPagesImage: UIImage? = UIImage(named: "onboardingSelected")
    
    override var numberOfPages: Int {
        didSet {
            updateDots()
        }
    }

    override var currentPage: Int {
        didSet {
            updateDots()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        if #available(iOS 14.0, *) {
            defaultConfigurationForiOS14AndAbove()
        } else {
            clipsToBounds = false
            pageIndicatorTintColor = .clear
            currentPageIndicatorTintColor = .clear
        }
    }

    private func defaultConfigurationForiOS14AndAbove() {
        for index in 0 ..< numberOfPages {
            if index == currentPage {
                setIndicatorImage(currentPageImage, forPage: index)
            } else {
                setIndicatorImage(otherPagesImage, forPage: index)
            }
        }
        pageIndicatorTintColor = UIColor.onboardingPaleGreen
        currentPageIndicatorTintColor = UIColor.tintGreen
    }

    private func updateDots() {
        if #available(iOS 14.0, *) {
            defaultConfigurationForiOS14AndAbove()
        } else {
            for (index, subview) in subviews.enumerated() {
                let imageView: UIImageView
                if let existingImageview = getImageView(forSubview: subview) {
                    imageView = existingImageview
                } else {
                    imageView = UIImageView(image: otherPagesImage)
                    
                    imageView.center = subview.center
                    subview.addSubview(imageView)
                    subview.clipsToBounds = false
                }
                if index == currentPage {
                    imageView.image = currentPageImage
                } else {
                    imageView.image = otherPagesImage
                }
            }
        }
    }

    private func getImageView(forSubview view: UIView) -> UIImageView? {
        if let imageView = view as? UIImageView {
            return imageView
        } else {
            let view = view.subviews.first { (view) -> Bool in
                return view is UIImageView
            } as? UIImageView

            return view
        }
    }
}
