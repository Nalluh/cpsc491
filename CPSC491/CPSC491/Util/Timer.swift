//
//  Timer.swift
//  CPSC491
//
//  Created by Allan Cortes on 3/6/24.
//

import Foundation
import Combine

extension WorkoutView{
    final class timerViewModel: ObservableObject{
        @Published var isRunning = false
        @Published var activeAlert = false
        @Published var isPaused = false
        @Published var timer: String
        @Published var timeStudied: Int = 0
        @Published var mins: Float =  0{
            didSet{// when value for mins is updated
                  // format the time for timer variable
                self.timer = "\(Int(mins)):00"
            }
        }
          

        
        private var startTime = 0;
        private var endingDate = Date();
        
        init(initialTimerValue: String = "0:00") {
                   self.timer = initialTimerValue
               }
    
        func setTimer(userTimer:String)
        {
            self.timer = userTimer
        }
        
        
        // when timer is started
        func startTimer(mins:Float){
            //Sets the time
            self.startTime = Int(mins)
            // Gets Current Date
            self.endingDate = Date()
            // Changes timer status to running
            self.isRunning = true
            self.isPaused = false
            // Calculates remaining time by adding mins value to current date
            // then counts down
            self.endingDate = Calendar.current.date(byAdding: .minute, value: Int(mins), to: endingDate)!
        }
        
        
        func reset(){
            //rest timer to preset time
            self.mins = Float(startTime)
            //switch state back to false or "off"
            self.isRunning = false
            self.isPaused = false
            //update timer value
            self.timer = "\(Int(mins)):00"
        }
        
        
        func pause(){
            self.isRunning = false
            self.isPaused = true
        }
        
        func updateTimer(){
            // if timer is not running just return
            guard isRunning else{
                return
            }
            //gets current date
            let currentTime = Date()
            
            //calculates timer value from our time in future -  current date
            let diffTime = endingDate.timeIntervalSince1970 - currentTime.timeIntervalSince1970
            
            // if the difference == 0 countdown is finished -> update states
            if diffTime <= 0 {
                self.timeStudied += startTime
                self.isRunning = false
                self.timer = "0:00"
                self.activeAlert = true
                return
            }
            
            let date = Date(timeIntervalSince1970: diffTime)
            //gets componets from Calendar
            let calendar = Calendar.current
            // using calendar componets we can grab the current minutes and seconds
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)
            
            //keeps track of timer
            self.mins=Float(minutes)
            //formats the timer values
            self.timer = String(format: "%d:%02d", minutes, seconds)
            
        }
    }
}



class Stopwatch: ObservableObject {
private var startTime: Date?
    private var accumulatedTime:TimeInterval = 0
    private var timer: Cancellable?
  
    @Published var isRunning = false {
        didSet {
            if self.isRunning {
               self.start()
            } else {
                self.stop()
            }
        }
    }
    @Published private(set) var elapsedTime: TimeInterval = 0
    private func start() -> Void {
        self.startTime = Date()
         self.timer?.cancel()
         self.timer = Timer.publish(every: 0.5, on: .main, in: .common)
         .autoconnect()
         .sink { _ in
                    self.elapsedTime = self.getElapsedTime()
                }
    }
    private func stop() -> Void {
        self.timer?.cancel()
        self.timer = nil
       // self.accumulatedTime = self.elapsedTime()
        self.startTime = nil
    }
    func reset() -> Void {
        self.accumulatedTime = 0
        self.elapsedTime = 0
        self.startTime = nil
        self.isRunning = false
    }
    private func getElapsedTime() -> TimeInterval {
        return -(self.startTime?.timeIntervalSinceNow ??     0)+self.accumulatedTime
    }
}
