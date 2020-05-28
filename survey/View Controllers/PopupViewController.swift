//
//  PopupViewController.swift
//  survey
//
//  Created by Selina Wang on 3/8/20.
//  Copyright © 2020 selina. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {
    
    var label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "textColor")
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var doneButton: UIButton = {
        let but = UIButton()
        but.backgroundColor = UIColor(named: "textColor")
        but.cornerRadius = 10
        but.setTitleColor(UIColor(named: "backgroundColor"), for: .normal)
        but.setTitle("Done", for: .normal)
        return but
    }()
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    var text: String = ""
    var img: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        label.text = text
//        print(text)
        
        view.backgroundColor = UIColor(named: "backgroundColor")
        view.addSubview(label)
        label.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 0, enableInsets: false)
        
        view.addSubview(doneButton)
        doneButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 30, paddingRight: 15, width: 0, height: 50, enableInsets: true)
        doneButton.addTarget(self, action: #selector(self.doneButtonClicked(sender:)), for: .touchUpInside)
       
        if let image = img {
            view.addSubview(imageView)
            imageView.anchor(top: nil, left: nil, bottom: doneButton.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 168, height: 300, enableInsets: false)
            imageView.image = image
            NSLayoutConstraint.activate([
                label.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -20),
                imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            
        } else {
            NSLayoutConstraint.activate([
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    }
    
    init(text: String, image: UIImage?) {
        self.text = text
        self.img = image
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @objc func doneButtonClicked(sender: UIButton) {
        dismiss(animated: true, completion: nil )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
