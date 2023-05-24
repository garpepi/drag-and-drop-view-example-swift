//
//  ViewController.swift
//  drag n drop view bervalue
//
//  Created by Garpepi Aotearoa on 24/05/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var toSOF: UIView!
    @IBOutlet weak var fromSOF: UIView!
    @IBOutlet weak var labelFrom: UILabel!
    @IBOutlet weak var labelTo: UILabel!

    var sourceDragFom : Bool = false
    var destinationDragFrom : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }

    func setup() {
//        toSOF.label.text = "Tadinya TOSOF"
//        fromSOF.label.text = "Tadinya FROMSOF"
        labelFrom.text = "From"
        labelTo.text = "To"

        let toDragInteraction = UIDragInteraction(delegate: self)
        toDragInteraction.isEnabled = true

        let fromDragInteraction = UIDragInteraction(delegate: self)
        fromDragInteraction.isEnabled = true

        toSOF.isUserInteractionEnabled = true
        fromSOF.isUserInteractionEnabled = true

        toSOF.addInteraction(toDragInteraction)
        fromSOF.addInteraction(fromDragInteraction)

        let toDropInteraction = UIDropInteraction(delegate: self)

        let fromDropInteraction = UIDropInteraction(delegate: self)
        toSOF.addInteraction(toDropInteraction)
        fromSOF.addInteraction(fromDropInteraction)
    }

    func switchLabel() {
        if sourceDragFom != destinationDragFrom {
            let toLabel = labelTo.text
            let fromLabel = labelFrom.text
            labelTo.text = fromLabel
            labelFrom.text = toLabel
        }
    }
}

extension ViewController: UIDragInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        let hitPoint = session.location(in: self.view)
        print(self.view.hitTest(hitPoint, with: nil) as? UIView)
        print(self.view.hitTest(hitPoint, with: nil) as? UIView == toSOF)
        print(self.view.hitTest(hitPoint, with: nil) as? UIView == fromSOF)

        if let hittedView = self.view.hitTest(hitPoint, with: nil) as? UIView {
            if hittedView == toSOF {
                sourceDragFom = false
                // DIbawah cuman buat animation doang
                let provider = NSItemProvider(object: labelTo.text as! NSString)
                let dragItem = UIDragItem(itemProvider: provider)
                return [dragItem]
            } else if hittedView == fromSOF {
                sourceDragFom = true
                let provider = NSItemProvider(object: labelFrom.text as! NSString)
                let dragItem = UIDragItem(itemProvider: provider)
                return [dragItem]
            }
        }
        return []
    }


}

extension ViewController: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        let hitPoint = session.location(in: self.view)
        print("-- DROP == \(hitPoint)")

        if let hittedView = self.view.hitTest(hitPoint, with: nil) as? UIView {
            if hittedView == toSOF {
                destinationDragFrom = false
                switchLabel()
            } else if hittedView == fromSOF {
                destinationDragFrom = true
                switchLabel()
            }
        }

    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
            // Propose to the system to copy the item from the source app
            return UIDropProposal(operation: .copy)
    }
}

