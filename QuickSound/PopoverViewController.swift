//
//  PopoverViewController.swift
//  QuickSound
//
//  Created by Thomas Di Meco on 18/03/2016.
//  Copyright © 2016 Thomas Di Meco. All rights reserved.
//

import Cocoa
import CoreAudio


class PopoverViewController: NSViewController {
    
    @IBOutlet var arrayController: NSArrayController!
    
    
    // MARK: - UI actions
    
    @IBAction func tableViewRowDoubleClicked(tableView: NSTableView) {
        guard tableView.clickedRow >= 0 else { return }
        guard let soundDic = self.arrayController.arrangedObjects[tableView.clickedRow] as? NSDictionary else { return }
        guard let soundObj = Sound(dictionary: soundDic) else { return }
        
        // Play sound
        if let soundURL = NSURL(string: soundObj.filePath) {
            let sound = NSSound(contentsOfURL: soundURL, byReference: true)
            let successOrNil = sound?.play()
            
            // Show alert
            if successOrNil == nil || !successOrNil! {
                let alert = NSAlert()
                alert.messageText = "Impossible de lire le son"
                alert.informativeText = "Le fichier est invalide ou introuvable."
                alert.alertStyle = .WarningAlertStyle
                alert.runModal()
            }
        }
    }
    
    @IBAction func addSoundAction(sender: AnyObject) {
        
        // Configure open panel
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = true
        openPanel.allowsMultipleSelection = true
        
        // Open panel
        let result = openPanel.runModal()
        if result == NSFileHandlingPanelOKButton {
            
            // Save each selected sound
            for fileURL in openPanel.URLs {
                let filePath = fileURL.absoluteString
                let soundDic = Sound(filePath: filePath).toDictionary()
                self.arrayController.addObject(soundDic)
            }
        }
    }
    
    @IBAction func showAboutWindow(sender: AnyObject) {
        // TODO
    }
    
    @IBAction func quitApplication(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(nil)
    }
}