//
//  Utilities.swift
//  CPSC491
//
//  Created by Allan Cortes on 2/12/24.
//

import Foundation
import UIKit
import SwiftUI

//helps define the current top view
// needed for the google sign in
final class Utilities {
    static let shared = Utilities()
    
    private init() {}
    
    @MainActor
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        let controller = controller ?? UIApplication.shared.keyWindow?.rootViewController
          
          if let navigationController = controller as? UINavigationController {
              return topViewController(controller: navigationController.visibleViewController)
          }
          if let tabController = controller as? UITabBarController {
              if let selected = tabController.selectedViewController {
                  return topViewController(controller: selected)
              }
          }
          if let presented = controller?.presentedViewController {
              return topViewController(controller: presented)
          }
          return controller
      }
}

// Text format for trifecta heading
struct TextDesign: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("AppleSDGothicNeo-Bold", size: 26))
            .fontWeight(.bold)
            .foregroundColor(Color.black)
            .padding(.trailing)
    }
}


func getTime(date:Date)-> String{
    let min = Int(-date.timeIntervalSinceNow)/60
    let hour = min/60
    let day = hour/24
    
    
    if min < 120 {
        return "\(min) minutes ago"
    }else if min >= 120 && hour < 48 {
        return "\(hour) hours ago"
    } else {
        return "\(day) days ago"
    }
    
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM-dd-yyyy"
    return formatter
}()


