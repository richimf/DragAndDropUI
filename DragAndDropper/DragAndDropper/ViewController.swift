//
//  ViewController.swift
//  DragAndDropper
//
//  Created by Ricardo on 31/05/23.
//

import Cocoa

class ViewController: NSViewController {
       
    lazy var dragView: DragView = {
        return DragView(frame: self.view.bounds)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dragView.delegate = self
        self.view.addSubview(dragView)
    }
}
extension ViewController: DragViewDelegate {
    func droppedFilePath(_ path: String?) {
        print("\(path)")
    }
}
