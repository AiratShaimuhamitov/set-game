//
//  ConcentrationThemeChooserViewController.swift
//  Concentration Stanford
//
//  Created by Айрат Шаймухамитов on 14.04.2020.
//  Copyright © 2020 Айрат Шаймухамитов. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {
    
    private let themes = [
        "Animals" : ["🐶", "🐱", "🐰", "🦊", "🐻", "🐵", "🦁", "🐼", "🐷"],
        "Fruits" : ["🍏", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🍑", "🥥"],
        "Sports" : ["⚽️", "🏀", "🥎", "🥊", "🏒", "⛸", "🎿", "🏊‍♂️", "🏂"],
        "Faces" : ["😄", "😎", "🤯", "😏", "🥳", "🥰", "🥴", "😵", "😇"]
    ]
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController
    ) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                return true
            }
        }
        return false
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
        } else if let cvc = lastSequeToConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        } else {
             performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    private var lastSequeToConcentrationViewController: ConcentrationViewController?
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                    lastSequeToConcentrationViewController = cvc
                }
            }
        }
    }
    
}
