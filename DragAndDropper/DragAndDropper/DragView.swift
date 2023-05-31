//
//  DraggingView.swift
//  DragAndDropper
//
//  Created by Ricardo on 31/05/23.
//

import Foundation
import Cocoa

protocol DragViewDelegate: AnyObject {
    func droppedFilePath(_ path: String?)
}

final class DragView: NSView {
    
    weak var delegate: DragViewDelegate?
    
    private var fileTypeIsOk = false
    private var fileTypes = ["sh"] // TODO: - ADD THE DESIRED FILE EXTENSION
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let draggedType = NSPasteboard.PasteboardType(kUTTypeURL as String)
        self.registerForDraggedTypes([draggedType])
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if checkExtension(drag: sender) {
            fileTypeIsOk = true
            return .copy
        } else {
            fileTypeIsOk = false
            return []
        }
    }
    
    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        if fileTypeIsOk {
            return .copy
        } else {
            return []
        }
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        if let board = sender.draggingPasteboard.propertyList(forType: convertToNSPasteboardPasteboardType("NSFilenamesPboardType")) as? NSArray,
            let filePath = board[0] as? String {
            delegate?.droppedFilePath(filePath)
            return true
        }
        return false
    }
    
    func checkExtension(drag: NSDraggingInfo) -> Bool {
        if let board = drag.draggingPasteboard.propertyList(forType: convertToNSPasteboardPasteboardType("NSFilenamesPboardType")) as? NSArray, let path = board[0] as? String {
            let url = NSURL(fileURLWithPath: path)
            if let fileExtension = url.pathExtension?.lowercased() {
                return fileTypes.contains(fileExtension)
            }
        }
        return false
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    private func convertToNSPasteboardPasteboardTypeArray(_ input: [String]) -> [NSPasteboard.PasteboardType] {
        return input.map { key in NSPasteboard.PasteboardType(key) }
    }

    // Helper function inserted by Swift 4.2 migrator.
    private func convertFromNSPasteboardPasteboardType(_ input: NSPasteboard.PasteboardType) -> String {
        return input.rawValue
    }

    // Helper function inserted by Swift 4.2 migrator.
    private func convertToNSPasteboardPasteboardType(_ input: String) -> NSPasteboard.PasteboardType {
        return NSPasteboard.PasteboardType(rawValue: input)
    }
}

