//
//  DreamsViewController.swift
//  sleepTracker
//
//  Created by Zhdanov Konstantin on 10.10.2024.
//

import UIKit
import SwiftData

protocol DreamsViewControllerProtocol: AnyObject {}

class DreamsViewController: UIViewController, DreamsViewControllerProtocol {

    var container: ModelContainer! // Контейнер данных Swift Data

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    private lazy var startDreamButton: UIButton = {
        let button = UIButton()
        button.setTitle("Начать сон", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startDreamTap), for: .touchUpInside)
        return button
    }()

    func setupViews() {
        view.addSubview(startDreamButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            startDreamButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -97),
            startDreamButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startDreamButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            startDreamButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            startDreamButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc
    func startDreamTap() {
        guard let container = container else {
            print("Контейнер данных не инициализирован.")
            return
        }
        
        // Создаем новую запись сна
        let newSleepRecord = SleepRecord(startTime: Date())

        // Сохраняем запись в контейнере
        do {
            try container.mainContext.insert(newSleepRecord)
            try container.mainContext.save()
            print("Сон успешно добавлен!")
        } catch {
            print("Ошибка при сохранении сна: \(error.localizedDescription)")
        }
    }
}
