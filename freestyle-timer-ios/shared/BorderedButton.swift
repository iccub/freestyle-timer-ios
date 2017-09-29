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

class BorderedButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2.0
        layer.cornerRadius = 8.0
    }
    
    override var isHighlighted: Bool {
        didSet {
            let fadedColor = tintColor.withAlphaComponent(0.2).cgColor
            
            if isHighlighted {
                layer.borderColor = fadedColor
            } else {
                layer.borderColor = tintColor.cgColor
                
                let animation = CABasicAnimation(keyPath: "backgroundColor")
                animation.fromValue = fadedColor
                animation.toValue = tintColor.cgColor
                animation.duration = 0.15
                layer.add(animation, forKey: "")
            }
        }
    }
}
