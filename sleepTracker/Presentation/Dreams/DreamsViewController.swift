//
//  DreamsViewController.swift
//  sleepTracker
//
//  Created by Zhdanov Konstantin on 10.10.2024.
//

import SwiftData
import UIKit

protocol DreamsViewControllerProtocol: AnyObject {}

class DreamsViewController: UIViewController, DreamsViewControllerProtocol {
    var container: ModelContainer! // Контейнер данных Swift Data
    private var sleepRecords: [SleepRecord] = []
    private var currentDate = Date() // Текущая выбранная дата

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        fetchSleepRecords()
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SleepRecordCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var startDreamButton: UIButton = {
        let button = UIButton()
        button.setTitle("Начать сон", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startDreamTap), for: .touchUpInside)
        return button
    }()

    private lazy var dateButton: UIButton = {
        let button = UIButton()
        button.setTitle("ZHOPA KONYA", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
        return button
    }()

    // Кнопка для перехода к предыдущему дню
    private lazy var previousDayButton: UIButton = {
        let button = UIButton()
        button.setTitle("<", for: .normal)
        button.addTarget(self, action: #selector(previousDayTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // Кнопка для перехода к следующему дню
    private lazy var nextDayButton: UIButton = {
        let button = UIButton()
        button.setTitle(">", for: .normal)
        button.addTarget(self, action: #selector(nextDayTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    func setupViews() {
        view.addSubview(previousDayButton)
        view.addSubview(dateButton)
        view.addSubview(nextDayButton)
        view.addSubview(tableView)
        view.addSubview(startDreamButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            dateButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            dateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            previousDayButton.trailingAnchor.constraint(equalTo: dateButton.leadingAnchor, constant: -8),
            previousDayButton.centerYAnchor.constraint(equalTo: dateButton.centerYAnchor),

            nextDayButton.leadingAnchor.constraint(equalTo: dateButton.trailingAnchor, constant: 8),
            nextDayButton.centerYAnchor.constraint(equalTo: dateButton.centerYAnchor),

            tableView.topAnchor.constraint(equalTo: dateButton.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: startDreamButton.topAnchor, constant: -16),

            startDreamButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -97),
            startDreamButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startDreamButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            startDreamButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            startDreamButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    @objc
    func startDreamTap() {
        guard let container = container else {
            //если забыл что за контейнер, то объявил в начале класса
            //var container: ModelContainer! // Контейнер данных Swift Data
            print("Контейнер данных не инициализирован.")
            return
        }

        let newSleepRecord = SleepRecord(startTime: Date())

        do {
            try container.mainContext.insert(newSleepRecord)
            try container.mainContext.save()
            print("Сон успешно добавлен!")
            fetchSleepRecords() // Обновляем список записей после добавления
        } catch {
            print("Ошибка при сохранении сна: \(error.localizedDescription)")
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }

    @objc
    private func dateButtonTapped() {
        // Создаем UIDatePicker
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date // Установить режим выбора даты
        datePicker.date = currentDate // Установить текущую дату
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)

        // Настраиваем Auto Layout для UIDatePicker
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePicker)

        // Устанавливаем ограничения для datePicker
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 250) // Высота UIPicker
        ])

        // Добавляем кнопку "Готово" для закрытия
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Готово", for: .normal)
        doneButton.addTarget(self, action: #selector(closeDatePicker(datePicker:)), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(doneButton)

        // Устанавливаем ограничения для doneButton
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 8),
            doneButton.centerXAnchor.constraint(equalTo: datePicker.centerXAnchor),
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])
    }

    // Метод для обработки изменения даты
    @objc
    private func dateChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
    }

    // Метод для закрытия UIDatePicker
    @objc
    private func closeDatePicker(datePicker: UIDatePicker) {
        datePicker.removeFromSuperview() // Удаляем UIDatePicker при нажатии "Готово"
        // Обновляем текст кнопки с выбранной датой
        dateButton.setTitle(formattedDate(currentDate), for: .normal)
        fetchSleepRecords() // Обновляем записи сна для выбранной даты
    }

    // Обработчик нажатия на кнопку "Предыдущий день"
    @objc
    private func previousDayTapped() {
        currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
        dateButton.setTitle(formattedDate(currentDate), for: .normal)
        fetchSleepRecords()
    }

    // Обработчик нажатия на кнопку "Следующий день"
    @objc
    private func nextDayTapped() {
        currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        dateButton.setTitle(formattedDate(currentDate), for: .normal)
        fetchSleepRecords()
    }

    // Метод для получения всех записей сна
    func fetchSleepRecords() {
        guard let container = container else { return }

        // Получаем начало и конец текущей выбранной даты
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: currentDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)?.addingTimeInterval(-1) ?? startOfDay

        // Создаем FetchDescriptor с фильтрацией по диапазону дат
        let fetchDescriptor = FetchDescriptor<SleepRecord>(
            predicate: #Predicate { $0.startTime >= startOfDay && $0.startTime <= endOfDay },
            sortBy: [SortDescriptor(\.startTime, order: .reverse)]
        )
        

        /*
         FetchDescriptor — это часть нового фреймворка Swift Data, который Apple представила на WWDC 2023. Он используется для описания условий выборки данных из базы данных в Swift Data. С его помощью можно задавать критерии поиска, сортировку и ограничение количества результатов, которые будут загружены из хранилища.

         Основные параметры, которые можно задать при создании FetchDescriptor:

         Predicate (where): Условие фильтрации, позволяющее указать, какие объекты должны быть включены в результаты выборки. Например, можно выбрать только те записи, которые соответствуют определённым условиям, например, "все сны, начавшиеся сегодня".

         SortDescriptors: Массив параметров сортировки, позволяющий определить порядок, в котором будут возвращены результаты. Например, можно отсортировать записи по дате начала сна.

         FetchLimit: Ограничивает количество возвращаемых объектов. Полезно для оптимизации выборок, чтобы не загружать слишком много данных за один раз.

         пример использования FetchDescriptor в Swift Data:

         swift
         
         let descriptor = FetchDescriptor<SleepRecord>(
             predicate: #Predicate { $0.startTime > Date() - 24 * 60 * 60 },
             sortBy: [SortDescriptor(\.startTime, order: .reverse)]
         )
         */

        do {
            sleepRecords = try container.mainContext.fetch(fetchDescriptor) // Получаем все записи
            tableView.reloadData()
        } catch {
            print("Ошибка при получении записей сна: \(error.localizedDescription)")
        }
    }
}

// MARK: - UITableViewDataSource

extension DreamsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sleepRecords.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SleepRecordCell", for: indexPath)
        let sleepRecord = sleepRecords[indexPath.row]
        cell.textLabel?.text = "Сон: \(sleepRecord.startTime)"
        return cell
    }
}

// MARK: - UITableViewDelegate

extension DreamsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Удаление записи о сне
            let sleepRecordToDelete = sleepRecords[indexPath.row]
            guard let container = container else { return }

            do {
                // Удаляем запись из контекста
                container.mainContext.delete(sleepRecordToDelete)
                try container.mainContext.save() // Сохраняем изменения в базе данных
                print("Запись сна удалена!")
                fetchSleepRecords() // Обновляем список после удаления
            } catch {
                print("Ошибка при удалении записи о сне: \(error.localizedDescription)")
            }
        }
    }
}
