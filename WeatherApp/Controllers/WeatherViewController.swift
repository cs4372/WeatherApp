//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Catherine Shing on 7/4/23.
//

import UIKit

class WeatherViewController: UIViewController {
    
    private let weatherViewModel: WeatherViewModel
    
    init(weatherViewModel: WeatherViewModel) {
        self.weatherViewModel = weatherViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // stack views
    let rootStackView = UIStackView()
    let topStackView = UIStackView()
    let topWeatherStackView = UIStackView()
    let bottomStackView = UIStackView()
    let bottomWeatherInfoStackView = UIStackView()
    
    // top stack view content
    let temperatureLabel = UILabel()
    let weatherDescriptionLabel = UILabel()
    let weatherImageView = UIImageView()
    
    // bottom stack view content
    let bottomStackContainer = UIView()
    let cityLabel = UILabel()
    let dateLabel = UILabel()
    let minTempLabel = UILabel()
    let maxTempLabel = UILabel()
    let humidityLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
        
        weatherViewModel.fetchWeatherData(city: "london")
        
        weatherViewModel.didUpdateWeatherData = { [weak self] in
            self?.updateUI()
        }
    }
    
    private func setupUI() {
        rootStackView.translatesAutoresizingMaskIntoConstraints = false
        
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.axis = .horizontal
        topStackView.spacing = 10
        topStackView.alignment = .top
        
        topWeatherStackView.translatesAutoresizingMaskIntoConstraints = false
        // topWeatherStackView.alignment = .leading
        topWeatherStackView.axis = .vertical
        topWeatherStackView.spacing = 10
        
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.font = UIFont.systemFont(ofSize: 80)
        temperatureLabel.tintColor = .label
        temperatureLabel.text = "12"
        
        weatherDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherDescriptionLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        weatherDescriptionLabel.text = "Sunny"
        
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.image = UIImage(systemName: "sun.max")
        weatherImageView.tintColor = .label
        weatherImageView.contentMode = .scaleAspectFill
        
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.axis = .vertical
        bottomStackView.alignment = .center
        bottomStackView.spacing = 10
        
        bottomStackContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomStackContainer.layer.borderWidth = 5.0
        bottomStackContainer.layer.borderColor = UIColor.blue.cgColor
        bottomStackContainer.layer.cornerRadius = 8.0
        bottomStackContainer.clipsToBounds = true
        
        // bottom stack view content
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.font = UIFont.systemFont(ofSize: 60)
        cityLabel.text = "New York"
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        dateLabel.text = "July 4"
        
        // bottomWeatherInfoStackView - min, max temp + humidity labels
        bottomWeatherInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomWeatherInfoStackView.axis = .horizontal
        bottomWeatherInfoStackView.alignment = .center
        bottomWeatherInfoStackView.spacing = 10
        
        minTempLabel.translatesAutoresizingMaskIntoConstraints = false
        minTempLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        minTempLabel.text = "L:13"
        
        maxTempLabel.translatesAutoresizingMaskIntoConstraints = false
        maxTempLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        maxTempLabel.text = "H:21"
        
        humidityLabel.translatesAutoresizingMaskIntoConstraints = false
        humidityLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        humidityLabel.text = "84"
    }
    
    private func setupLayout() {
        view.addSubview(rootStackView)
        
        rootStackView.addSubview(topStackView)
        rootStackView.addSubview(bottomStackContainer)
        
        topStackView.addArrangedSubview(topWeatherStackView)
        topStackView.addArrangedSubview(weatherImageView)
        
        topWeatherStackView.addArrangedSubview(temperatureLabel)
        topWeatherStackView.addArrangedSubview(weatherDescriptionLabel)
        
        bottomStackContainer.addSubview(bottomStackView)
        
        bottomStackView.addArrangedSubview(cityLabel)
        bottomStackView.addArrangedSubview(dateLabel)
        bottomStackView.addArrangedSubview(bottomWeatherInfoStackView)
        
        bottomWeatherInfoStackView.addArrangedSubview(minTempLabel)
        bottomWeatherInfoStackView.addArrangedSubview(maxTempLabel)
        bottomStackView.addArrangedSubview(humidityLabel)
                                
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rootStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: rootStackView.trailingAnchor, multiplier: 2),
            rootStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            topStackView.topAnchor.constraint(equalToSystemSpacingBelow: rootStackView.topAnchor, multiplier: 2),
            topStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: rootStackView.leadingAnchor, multiplier: 2),
            rootStackView.trailingAnchor.constraint(equalToSystemSpacingAfter: topStackView.trailingAnchor, multiplier: 2),

            bottomStackContainer.centerXAnchor.constraint(equalTo: rootStackView.centerXAnchor),
            bottomStackContainer.centerYAnchor.constraint(equalTo: rootStackView.centerYAnchor),
            bottomStackContainer.leadingAnchor.constraint(equalToSystemSpacingAfter: rootStackView.leadingAnchor, multiplier: 2),
            rootStackView.trailingAnchor.constraint(equalToSystemSpacingAfter: bottomStackContainer.trailingAnchor, multiplier: 2),
            
            bottomStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: bottomStackContainer.leadingAnchor, multiplier: 2),
            bottomStackContainer.trailingAnchor.constraint(equalToSystemSpacingAfter: bottomStackView.trailingAnchor, multiplier: 2),
            bottomStackView.topAnchor.constraint(equalToSystemSpacingBelow: bottomStackContainer.topAnchor, multiplier: 2),
            bottomStackContainer.bottomAnchor.constraint(equalToSystemSpacingBelow: bottomStackView.bottomAnchor, multiplier: 2),
            
            weatherImageView.heightAnchor.constraint(equalToConstant: 100),
            weatherImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }

    
    private func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let weatherData = self?.weatherViewModel.weatherData else {
                return
            }
            
            let fahrenheitTemperature = Helpers.convertKelvinToFahrenheit(kelvin: weatherData.main.temp)
            self?.temperatureLabel.text = "\(fahrenheitTemperature)°F"
            self?.weatherDescriptionLabel.text = weatherData.weather.first?.description
            self?.cityLabel.text = weatherData.name
            self?.dateLabel.text = Helpers.getTodayDate()
            self?.minTempLabel.text = "L:\(Helpers.convertKelvinToFahrenheit(kelvin: weatherData.main.minTemp))"
            self?.maxTempLabel.text = "H:\(Helpers.convertKelvinToFahrenheit(kelvin: weatherData.main.maxTemp))"
            self?.humidityLabel.text = "Humidity:\(weatherData.main.humidity)"
            let weatherIconInfo = Helpers.getWeatherIconName(for: weatherData.weather.first?.id ?? 0)
            self?.weatherImageView.image = UIImage(systemName: weatherIconInfo.name)
            self?.weatherImageView.tintColor = weatherIconInfo.backgroundColor
        }
    }
}
