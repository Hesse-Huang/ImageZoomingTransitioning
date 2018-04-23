//
//  ViewController.swift
//  ImageZoomingTransitioning
//
//  Created by Hesse Huang on 23/4/2018.
//  Copyright © 2018 Hesse. All rights reserved.
//

import UIKit

class ViewController : UITableViewController, UIViewControllerTransitioningDelegate {
    
    var selectedSourceImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Main"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if cell.viewWithTag(100) == nil {
            let imageView = UIImageView(image: #imageLiteral(resourceName: "red_panda"))
            imageView.frame.origin = CGPoint(x: 20, y: 20)
            imageView.frame.size = CGSize(width: 100, height: 100)
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.tag = 100
            cell.contentView.addSubview(imageView)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        selectedSourceImageView = cell?.viewWithTag(100) as? UIImageView
        
        let di = DetailImageViewController(nibName: nil, bundle: nil)
        di.imageView.image = selectedSourceImageView?.image
        di.transitioningDelegate = self
        present(di, animated: true, completion: nil)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard
            let sourceImageView = selectedSourceImageView,
            let destinationImageView = (presented as? DetailImageViewController)?.imageView else { return nil }
        return ImageZoomingTrainsitionPresenter(from: sourceImageView, to: destinationImageView)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard
            let sourceImageView = (dismissed as? DetailImageViewController)?.imageView,
            let destinationImageView = selectedSourceImageView else { return nil }
        return ImageZoomingTransitionDismisser(from: sourceImageView, to: destinationImageView)
    }
    
    
}

class DetailImageViewController: UIViewController {
    
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        imageView.frame.size = CGSize(width: 300, height: 300)
        imageView.center = view.center
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        
        let btn = UIButton(type: .system)
        btn.setTitle("dismiss", for: .normal)
        btn.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        btn.sizeToFit()
        btn.center = imageView.center
        btn.center.y += 200
        view.addSubview(btn)
    }
    
    @objc func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
}





