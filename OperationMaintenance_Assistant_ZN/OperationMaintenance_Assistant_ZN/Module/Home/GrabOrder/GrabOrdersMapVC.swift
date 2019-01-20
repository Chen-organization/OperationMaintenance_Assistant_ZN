//
//  GrabOrdersMapVC.swift
//  OperationMaintenance_Assistant_ZN
//
//  Created by Chen on 2019/1/20.
//  Copyright © 2019年 Chen. All rights reserved.
//

import UIKit


class GrabOrdersMapVC: UIViewController, BMKMapViewDelegate,BMKLocationManagerDelegate{

    var _mapView: BMKMapView?
    var locationManager = BMKLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.fd_interactivePopDisabled = true
        
        _mapView = BMKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(_mapView!)
        _mapView?.zoomLevel = 13
        _mapView?.isRotateEnabled  = false
        _mapView?.showsUserLocation = true

        
        locationManager.delegate = self as BMKLocationManagerDelegate
        locationManager.coordinateType = BMKLocationCoordinateType.BMK09LL
        locationManager.distanceFilter = kCLLocationAccuracyBestForNavigation;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.activityType = CLActivityType.automotiveNavigation
        locationManager.pausesLocationUpdatesAutomatically = false;
        locationManager.allowsBackgroundLocationUpdates = false;// YES的话是可以进行后台定位的，但需要项目配置，否则会报错，具体参考开发文档
        locationManager.locationTimeout = 10;
        locationManager.reGeocodeTimeout = 10;
        locationManager.startUpdatingLocation()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        _mapView?.viewWillAppear()
        _mapView?.delegate = self // 此处记得不用的时候需要置nil，否则影响内存的释放
        
        // 取消所有标注的选中状态
        //        for (let annotation : BMKAnnotation in _mapView.annotations) {
        //            [_mapView deselectAnnotation:annotation animated:NO];
        //        }
        
//        if _mapView!.annotations.count > 0 {
//
//            for i in 0..<_mapView!.annotations.count{
//
//                let annotation : BMKAnnotation  = _mapView!.annotations[i] as! BMKAnnotation
//
//                _mapView?.deselectAnnotation(annotation, animated: false)
//
//            }
//        }
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated);
        
        _mapView?.viewWillDisappear()
        _mapView?.delegate = nil // 不用时，置nil
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    // MARK: -----------  定位 delegate
    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate location: BMKLocation?, orError error: Error?) {
        
        if let a = location?.location?.coordinate {
            
            _mapView?.centerCoordinate = a
            
            locationManager.stopUpdatingLocation()
        }
        
    }
    
    // MARK: -----------  mapview delegate

    func mapView(_ mapView: BMKMapView!, regionDidChangeAnimated animated: Bool) {
        
        
    }
    
    
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        
        return nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
