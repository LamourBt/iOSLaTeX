//
//  ViewController.swift
//  iOSLaTeX
//
//  Created by shujew on 07/23/2018.
//  Copyright (c) 2018 shujew. All rights reserved.
//

import UIKit
import iOSLaTeX

class ViewController: UIViewController {

    @IBOutlet weak var laTeXImageView: LaTeXImageView!
    @IBOutlet weak var textfield: UITextField!
    
    @IBOutlet weak var laTexImageViewHeightConstraint: NSLayoutConstraint!
    
    private var laTeXRenderer: LaTeXRenderer?
    
    let exampleLaTeXArray = [
        "$$(a_1 + a_2)^2 = a_1^2 + 2a_1a_2 + a_2^2$$",
        "$$x = \\frac{-b \\pm \\sqrt{b^2-4ac}}{2a}$$",
        "$$\\sigma = \\sqrt{\\frac{1}{N}\\sum_{i=1}^N (x_i - \\mu)^2}$$",
        "$$\\neg(P\\land Q) \\iff (\\neg P)\\lor(\\neg Q)$$",
        "$$\\log_b(x) = \\frac{\\log_a(x)}{\\log_a(b)}$$",
        "$$\\cos(\\theta + \\varphi) = \\cos(\\theta)\\cos(\\varphi) - \\sin(\\theta)\\sin(\\varphi)$$",
        "[math]By\\: separation\\:of\\:variables\\\\firstly\\:devide\\:by\\:3x\\:we\\:get\\:t^2\\dfrac{dx}{dt}=\\dfrac{1-4x^2}{3x}\\\\separate\\:variables\\: you\\:get\\:\\:\\dfrac{3xdx}{1-4x^2}=\\dfrac{dt}{t^2}\\\\now\\:integrate\\:you\\:get\\\\\\dfrac{3}{8}\\ln(1-4x^2)=\\dfrac{1}{t}+C\\\\or\\:taking\\: exponential\\:of:the\\: equation\\:we\\:get\\:(1-4x^2)^{3/8}=Ce^{1/t}\\\\ifx(1)=1\\:we\\:get\\:C=\\dfrac{-3^{3/8}}{e}[/math]"
    ]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         * You don't have to inject a LaTeX renderer but it is useful
         * for cases where you have to render multiple LaTeX images but
         * don't want 1 LaTeXRenderer per imageView
         */
        self.laTeXRenderer = LaTeXRenderer(parentView: self.view)
        
        self.laTeXImageView.inject(laTeXRenderer: self.laTeXRenderer!)
        self.laTeXImageView.heightConstraint = laTexImageViewHeightConstraint
        
        self.generateLaTeXButtonTapped(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func renderLaTeX(_ laTeX: String){
        self.view.endEditing(true)
        laTeXImageView.backgroundColorWhileRenderingLaTeX = self.view.backgroundColor
        
        /*
        * You can use  `laTeXImageView.laTeX = laTeX` if you don't need the completion handler
        */
        laTeXImageView.render(laTeX, shouldResize: true) { (error) in
            if let error = error {
                print("\(error)")
                return
            }
            
            print("Successfully rendered LaTeX")
        }
    }
    
    @IBAction func generateLaTeXButtonTapped(_ sender: Any) {
        let textfieldText = textfield.text
        
        if let laTeX = textfieldText?.trimmingCharacters(in: .whitespaces), !laTeX.isEmpty, !exampleLaTeXArray.contains(laTeX) {
            renderLaTeX(laTeX)
        } else {
            let randomNum:UInt32 = arc4random_uniform(UInt32(exampleLaTeXArray.count))
            let defaultLaTeXText = exampleLaTeXArray[Int(randomNum)]
            
            textfield.text = defaultLaTeXText
            renderLaTeX(defaultLaTeXText)
        }
    }
}

