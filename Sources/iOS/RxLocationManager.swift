//
//  RxLocationManager.swift
//  PaperChat
//
//  Created by HaoYu on 16/6/14.
//  Copyright © 2016年 HaoYu. All rights reserved.
//
#if os(iOS)
    import Foundation
    import RxSwift
    import CoreLocation
    
    //MARK: RxLocationManager
    public class RxLocationManager{
        private static var defaultLocationMgr: Bridge = {
            let locMgr = Bridge()
            locMgr.didChangeAuthorizationStatus = {
                clLocMgr, status in
                authorizationStatusSink.onNext(status)
                enabledSink.onNext(CLLocationManager.locationServicesEnabled())
            }
            return locMgr
        }()
        
        private static var enabledSink:ReplaySubject<Bool> = {
            let replaySubject:ReplaySubject<Bool> = ReplaySubject.create(bufferSize: 1)
            replaySubject.onNext(CLLocationManager.locationServicesEnabled())
            //Force initialize defaultLocationMgr, since it's always lazy
            defaultLocationMgr = defaultLocationMgr
            return replaySubject
        }()
        
        public static var enabled:Observable<Bool>{
            get{
                return enabledSink.distinctUntilChanged()
            }
        }
        
        private static var authorizationStatusSink:ReplaySubject<CLAuthorizationStatus> = {
            let replaySubject:ReplaySubject<CLAuthorizationStatus> = ReplaySubject.create(bufferSize: 1)
            replaySubject.onNext(CLLocationManager.authorizationStatus())
            //Force initialize defaultLocationMgr, since it's always lazy
            defaultLocationMgr = defaultLocationMgr
            return replaySubject
        }()
        
        public static var authorizationStatus: Observable<CLAuthorizationStatus>{
            get{
                return authorizationStatusSink.distinctUntilChanged()
            }
        }
        
        public static func requestWhenInUseAuthorization(){
            defaultLocationMgr.manager.requestWhenInUseAuthorization()
        }
        
        public static func requestAlwaysAuthorization(){
            defaultLocationMgr.manager.requestAlwaysAuthorization()
        }
        
        public static func isMonitoringAvailableForClass(regionClass: AnyClass) -> Bool{
            return CLLocationManager.isMonitoringAvailableForClass(regionClass)
        }
        
        public static let deferredLocationUpdatesAvailable = CLLocationManager.deferredLocationUpdatesAvailable()
        
        public static let headingAvailable = CLLocationManager.headingAvailable()
        
        public static let isRangingAvailable = CLLocationManager.isRangingAvailable()
        
        public static let significantLocationChangeMonitoringAvailable = CLLocationManager.significantLocationChangeMonitoringAvailable()
        
        public static let Standard: StandardLocationService = DefaultStandardLocationService()
        
        public static let SignificantLocation: SignificantLocationUpdateService = DefaultSignificantLocationUpdateService()
        
        public static let VisitMonitoring: MonitoringVisitsService = DefaultMonitoringVisitsService()
        
        public static let HeadingUpdate: HeadingUpdateService = DefaultHeadingUpdateService()
        
        public static let RegionMonitoring: RegionMonitoringService = DefaultRegionMonitoringService()
        
    }
#endif

