//
//  LocationManager.swift
//  BList
//
//  Created by Venkata Ajay Sai (Paras) on 21/11/22.
//

import UIKit
import CoreLocation
import MapKit
class LocationManager:NSObject{
    // MARK: - PROPERTIES
    var locationManager:CLLocationManager = CLLocationManager()
    static let shared = LocationManager()
    var continuousUpdate = false
    private override init() {}
    private var retrievedCurrentLocation : ((_ location: CLLocation)->())?
    
    
    // MARK: - KEY FUNCTIONS
    
    /// This function checks the authorization status of location manager
    private func checkAuthorizationStatus(){
        if #available(iOS 14.0, *){
            switch locationManager.authorizationStatus{
            case .notDetermined:
                locationManager.requestAlwaysAuthorization()
            case .restricted:
                showPopUp(for: .LocationAccessRestricted)
            case .denied:
                DispatchQueue.global().async {
                    if CLLocationManager.locationServicesEnabled(){
                        DispatchQueue.main.async {
                            self.showPopUp(for: .LocationAccessDenied)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showPopUp(for: .LocationServiceDisabled)
                        }
                    }
                }
            case .authorizedAlways,.authorizedWhenInUse:
                DispatchQueue.main.async {
                    if let navVC = UIApplication.shared.windows.first?.rootViewController as? UINavigationController, let topVC = navVC.viewControllers.last, let alertVC = topVC.presentedViewController{
                        alertVC.dismiss(animated: true)
                    }
                }
                locationManager.startUpdatingLocation()
            @unknown default:
                break
            }
        }
        else {
            switch CLLocationManager.authorizationStatus(){
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                showPopUp(for: .LocationAccessRestricted)
            case .denied:
                if CLLocationManager.locationServicesEnabled(){
                    self.showPopUp(for: .LocationServiceDisabled)
                }
                else{
                    showPopUp(for: .LocationAccessDenied)
                }
            case .authorizedAlways,.authorizedWhenInUse:
                locationManager.startUpdatingLocation()
            @unknown default:
                break
            }
        }
    }
    
    private func showPopUp(for locationError: LocationStatus){
        var msg = ""
        switch locationError{
        case .LocationServiceDisabled:
            msg = "Please enable location services to let us know your current location"
        case .LocationAccessDenied, .UnableToRetrieveLocation:
            msg = "Please allow location access to let us know your current location"
        case .LocationAccessRestricted:
            msg = "Location access is restricted by parental control. Please "
        }
        let alert = UIAlertController(title:"Blist App uses location services to show your current location on the map", message:msg, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: {action in
            
            // open the app permission in Settings app
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        })
        alert.addAction(settingsAction)
        alert.preferredAction = settingsAction
        if let navVC = UIApplication.shared.windows.first?.rootViewController as? UINavigationController, let topVC = navVC.viewControllers.last{
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { action in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: K.NotificationKeys.locationUpdate), object: nil)
                topVC.dismiss(animated: true, completion: nil)
            }
            alert.addAction(cancelAction)
            topVC.present(alert, animated: true, completion: nil)
        }
    }
    
    /// This function gets the current location of the user
    func getCurrentLocation(continuousUpdate: Bool = false, _ completion: @escaping ((_ location: CLLocation) -> Void)){
        self.retrievedCurrentLocation = completion
        self.continuousUpdate = continuousUpdate
        DispatchQueue.global().async {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.distanceFilter = 100
            self.locationManager.delegate = self
            self.checkAuthorizationStatus()
        }
    }
    
    /// This function gets the distance between two locations
    /// - Returns: This function returns distance in miles and in meters
    func getDistance(from loc1: CLLocation?, to loc2: CLLocation?) async -> (distanceInMiles: Double?, distanceInMeters: Double?){
        guard let fromLoc = loc1, let toLoc = loc2 else{
            return (nil,nil)}
        let start = MKMapItem(placemark: MKPlacemark(coordinate: fromLoc.coordinate))
        let end = MKMapItem(placemark: MKPlacemark(coordinate: toLoc.coordinate))
        
        // Now we've got start and end MKMapItems for MapKit, based on the placemarks. Build a request for
        // a route by car.
        let request: MKDirections.Request = MKDirections.Request()
        request.source = start
        request.destination = end
        request.transportType = MKDirectionsTransportType.automobile
        
        // Execute the request on an MKDirections object
        let directions = try? await MKDirections(request: request).calculate()
        if let routes = directions?.routes{
            let route = routes[0]
            print(route.distance)
            
            let distanceInMiles = (Double(route.distance)/1609.344)
            return (distanceInMiles,route.distance)
        }
        //No Routes are available between start and end locations
        return (nil,nil)
    }
    
    
    /// This function returns the address for the given coordinate
    /// - Parameters:
    ///   - coordinate: Send the coordinate
    ///   - addressInfo: This is an enum. We have two different values. One value returns only state and country and another value returns entire address.
    func getAddress(for coordinate: CLLocationCoordinate2D) async throws -> (completeAddress: String?, city_state_country: (city:String?,state:String?,country:String?)?) {
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        if let placeMarks = try? await geoCoder.reverseGeocodeLocation(location), let placeMark = placeMarks.first{
            return (getCompleteAddress(for: placeMark), getCity_State_Country(for: placeMark))
            
        }
        return (nil,nil)
    }
    
    /// This function returns complete address of a given placemark
    func getCompleteAddress(for placeMark: CLPlacemark) -> String {
        var address = [String]()
        // Street Number
        if let streetNumber = placeMark.subThoroughfare{
            address.append(streetNumber)
        }
        // Street Name
        if let streetName = placeMark.thoroughfare{
            address.append(streetName)
        }
        // Town / Village
        if let subLocality = placeMark.subLocality{
            address.append(subLocality)
        }
        // City
        if let city = placeMark.locality{
            address.append(city)
        }
        // State
        if let administrativeArea = placeMark.administrativeArea{
            address.append(administrativeArea)
        }
        // Country
        if let country = placeMark.country{
            address.append(country)
        }
        // Postal Code
        if let pinCode = placeMark.postalCode{
            address.append(pinCode)
        }
        return address.joined(separator: ", ")
    }
    func appendAddress(components: (city:String?, state:String?, country:String?)) -> String{
        var address = [String]()
        // City
        if let city = components.city{
            address.append(city)
        }
        // State
        if let state = components.state{
            address.append(state)
        }
        // Country
        if let country = components.country{
            address.append(country)
        }
        return address.joined(separator: ", ")
    }
    func getCity_State_Country(for placeMark: CLPlacemark) -> (city:String?, state:String?, country:String?) {
        return (placeMark.locality,placeMark.administrativeArea,placeMark.country)
    }
    
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else{return}
        if !continuousUpdate{
            locationManager.stopUpdatingLocation()
        }
        retrievedCurrentLocation?(CLLocation.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorizationStatus()
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorizationStatus()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied{
            // Location updates are not authorized.
            // To prevent forever looping of `didFailWithError` callback
            locationManager.stopMonitoringSignificantLocationChanges()
            showPopUp(for: .UnableToRetrieveLocation)
            return
        }
        
    }
}

// MARK: - EXTENSIONS
extension LocationManager{
    enum AddressInfo{
        case all
        case city_state_country
    }
    enum LocationStatus{
        case LocationServiceDisabled
        case LocationAccessDenied
        case LocationAccessRestricted
        case UnableToRetrieveLocation
    }
}

// MARK: - STRUCTS
/// Using this struct we are calling
struct Locations: AsyncSequence{
    typealias Element = (completeAddress: String?, city_state_country: (city:String?, state:String?, country:String?)?)
    let coordinates : [CLLocationCoordinate2D]
    init(coordinates: [CLLocationCoordinate2D]) {
        self.coordinates = coordinates
    }
    func makeAsyncIterator() -> LocationIterator {
        return LocationIterator(coordinates: coordinates)
    }
}
struct LocationIterator: AsyncIteratorProtocol{
    
    typealias Element = (completeAddress: String?, city_state_country: (city:String?, state:String?, country:String?)?)
    let coordinates: [CLLocationCoordinate2D]
    init(coordinates: [CLLocationCoordinate2D]) {
        self.coordinates = coordinates
    }
    private var index = 0
    
    mutating func next() async throws -> (completeAddress: String?, city_state_country: (city:String?, state:String?, country:String?)?)? {
        // CHECK BOUNDS
        guard index < coordinates.count else{
            return nil
        }
        
        // COORDINATE, INCREMENT INDEX
        let coordinate = coordinates[index]
        index += 1
        
        // API CALL or CALLING ASYNC METHOD
        let address = try await LocationManager.shared.getAddress(for: coordinate)
        
        // RETURN ADDRESS
        return address
    }
    
}
