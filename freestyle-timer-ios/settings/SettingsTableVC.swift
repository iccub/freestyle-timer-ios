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
import StoreKit
import os.log

/**
View Controller for settings screen.
 */
class SettingsTableVC: UITableViewController {
    static let log = OSLog(subsystem: "com.michalbuczek.freestyle_timer_ios.logs", category: "SettingsTableVC")
    
    // MARK: - IBOutlets
    @IBOutlet weak var playersLabel: UILabel!
    @IBOutlet weak var roundDurationLabel: UILabel!
    @IBOutlet weak var numberOfRoundsLabel: UILabel!
    @IBOutlet weak var battlePreparationTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var soundIntervalLabel: UILabel!
    @IBOutlet weak var qualPreparationTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    @IBOutlet weak var appVersion: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            appVersion.text = version
        }
        
        let settings = UserDefaults.standard

        playersLabel.text = "\(settings.integer(forKey: Settings.Battle.Keys.players))"
        roundDurationLabel.text = settings.integer(forKey: Settings.Battle.Keys.roundDuration).secondsToTime()
        numberOfRoundsLabel.text = "\(settings.integer(forKey: Settings.Battle.Keys.numberOfRounds))"
        battlePreparationTimeLabel.text = "\(settings.integer(forKey: Settings.Battle.Keys.preparationTime)) seconds"
        
        calculateTotalTime()
        
        durationLabel.text = settings.integer(forKey: Settings.Qualification.Keys.duration).secondsToTime()
        soundIntervalLabel.text = settings.integer(forKey: Settings.Qualification.Keys.soundInterval).secondsToTime()
        qualPreparationTimeLabel.text = "\(settings.integer(forKey: Settings.Qualification.Keys.preparationTime)) seconds"
    }
    
    /**
     Calculates total time of battle timer. The time is based on number of players, rounds, and round duration.
     */
    private func calculateTotalTime() {
        let settings = UserDefaults.standard
        
        let players = settings.integer(forKey: Settings.Battle.Keys.players)
        let roundDuration = settings.integer(forKey: Settings.Battle.Keys.roundDuration)
        let numberOfRounds = settings.integer(forKey: Settings.Battle.Keys.numberOfRounds)
        
        let total = players * roundDuration * numberOfRounds
        os_log("Calculated total time: %i seconds", log: SettingsTableVC.log, type: .debug, total)
        totalTimeLabel.text = total.secondsToTime()
    }
    
    // MARK: - TablaView methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // We use SKStoreReviewController.requestReview() for app rating, but it's only availiable from iOS 10.3 and
        // higher. This is not crucial functionallity so we just hide the rate app cell for not compatibile devices
        
        if #available(iOS 10.3, *) {
            return super.tableView(tableView, heightForRowAt: indexPath)
        } else {
            let rateAppCellTag = 10
            let cell = tableView.cellForRow(at: indexPath)
            
            return cell?.tag == rateAppCellTag ? 0 : super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    // MARK: - IBActions
    @IBAction func rateAppTapped(_ sender: UIButton) {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
        os_log("rateAppTapped on device lower than iOS 10.3", log: SettingsTableVC.log, type: .error)
    }
    
    // MARK: - Segue navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = segue.identifier else { return }
        os_log("segue id: %@", log: SettingsTableVC.log, type: .info, id)
        
        // Generic TableViewController is used for all settings type, as they all are similar, all have some
        // predefined options and values are integers(time in seconds or number of rounds/players)
        // Segue fills needed data, current value, settings options and navigation title
        guard let vc = segue.destination as? SettingsOptionsTableVC else {
            os_log("Destination segue is not type of SettingsOptionsTableVC", log: SettingsTableVC.log, type: .error)
            return
        }
        vc.delegate = self
        
        switch id {
        case "playersOption":
            vc.optionKey = Settings.Battle.Keys.players
            vc.options = Settings.Battle.Options.playerOptions
            break
        case "roundDurationOption":
            vc.optionKey = Settings.Battle.Keys.roundDuration
            vc.options = Settings.Battle.Options.roundDuration
            break
        case "numberOfRoundsOption":
            vc.optionKey = Settings.Battle.Keys.numberOfRounds
            vc.options = Settings.Battle.Options.numberOfRounds
            break
        case "battlePreparationTimeOption":
            vc.optionKey = Settings.Battle.Keys.preparationTime
            vc.options = Settings.Battle.Options.preparationTime
            break
        case "durationOption":
            vc.optionKey = Settings.Qualification.Keys.duration
            vc.options = Settings.Qualification.Options.duration
            break
        case "soundIntervalOption":
            vc.optionKey = Settings.Qualification.Keys.soundInterval
            vc.options = Settings.Qualification.Options.soundInterval
            break
        case "qualificationPreparationTimeOption":
            vc.optionKey = Settings.Qualification.Keys.preparationTime
            vc.options = Settings.Qualification.Options.preparationTime
            break
        default:
            os_log("Segue id does not match any of SettingsOption segues", log: SettingsTableVC.log, type: .error)
            break
        }
        
        guard let cell = sender as? UITableViewCell else {
            os_log("Segue was not called by a UITableViewCell", log: SettingsTableVC.log, type: .error)
            return
        }
        
        vc.navigationItem.title = cell.textLabel?.text
    }
}

// MARK: - Delegates
extension SettingsTableVC: SettingsOptionDelegate {
    func optionChanged(key: String) {
        let newValue = UserDefaults.standard.integer(forKey: key)
        
        os_log("Settings option for key %@ changed, new value: %i", log: SettingsTableVC.log, type: .info, key, newValue)
        
        switch key {
        case Settings.Battle.Keys.players:
            playersLabel.text = "\(newValue)"
            calculateTotalTime()
            break
        case Settings.Battle.Keys.roundDuration:
            roundDurationLabel.text = newValue.secondsToTime()
            calculateTotalTime()
            break
        case Settings.Battle.Keys.numberOfRounds:
            numberOfRoundsLabel.text = "\(newValue)"
            calculateTotalTime()
            break
        case Settings.Battle.Keys.preparationTime:
            battlePreparationTimeLabel.text = "\(newValue) seconds"
            break
        case Settings.Qualification.Keys.duration:
            durationLabel.text = newValue.secondsToTime()
            break
        case Settings.Qualification.Keys.soundInterval:
            soundIntervalLabel.text = newValue.secondsToTime()
            break
        case Settings.Qualification.Keys.preparationTime:
            qualPreparationTimeLabel.text = "\(newValue) seconds"
            break
        default:
            break
        }
    }
}
