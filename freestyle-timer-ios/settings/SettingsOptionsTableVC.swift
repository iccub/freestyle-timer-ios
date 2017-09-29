/*
 Copyright © 2017 Michał Buczek.
 
 This file is part of Freestyle Timer.
 
 Freestyle Timer is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 Freestyle Timer is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Freestyle Timer.  If not, see <http://www.gnu.org/licenses/>.
 */

import UIKit
import os.log

/**
 When user changes settings, it's refreshed in SettingsTableVC
 */
protocol SettingsOptionDelegate: class {
    func optionChanged(key: String)
}

/**
 Generic ViewController for all settings options. All app settings are similar, have some predefinied options and
 use int as a value(time in seconds or number of rounds/players)
 */
class SettingsOptionsTableVC: UITableViewController {
    static let log = OSLog(subsystem: "com.michalbuczek.freestyle_timer_ios.logs", category: "SettingsOptionsTableVC")
    
    // MARK: - Data from segue
    var optionKey: String!
    var options: [Settings.SettingsOption]!
    weak var delegate: SettingsOptionDelegate?
    
    private var currentValue = 0 // 0 means the value does not exists(same as in UserDefaults.integer method)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        currentValue = Settings.int(for: optionKey)
        os_log("Loaded settings for %@, current value: %i, number of options: %i",
               log: SettingsOptionsTableVC.log, type: .info, optionKey, currentValue, options.count)
        
        if currentValue == 0 {
            os_log("Could not find settings value for %@ key", log: SettingsOptionsTableVC.log, type: .error, optionKey)
        }
    }

    // MARK: - TableView methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsOption", for: indexPath)
        
        let option = options[indexPath.row]
        
        cell.textLabel?.text = option.name
        cell.accessoryType = option.value == currentValue ? .checkmark : .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedValue = options[indexPath.row].value
        if selectedValue == currentValue {
            os_log("Selected value is the same as previous one, skipping", log: SettingsOptionsTableVC.log, type: .debug)
            return
        }
        
        UserDefaults.standard.set(selectedValue, forKey: optionKey)
        currentValue = selectedValue
        delegate?.optionChanged(key: optionKey)
        
        // Reload data must be called to change cell checkmark position
        tableView.reloadData()
    }
}
