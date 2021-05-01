//
//  Drops
//
//  Copyright (c) 2021-Present Omar Albeik - https://github.com/omaralbeik
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit
import Drops

final class ViewController: UIViewController {
    enum Section {
        case main
    }
    typealias Row = String
    typealias DataSource = UITableViewDiffableDataSource<Section, Row>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Drops"
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        dataSource = .init(tableView: tableView) { view, _, row in
            let cell = view.dequeueReusableCell(withIdentifier: "cell")
            cell?.textLabel?.text = row
            return cell
        }

        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(drops.map(\.title))
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private let drops: [(title: String, drop: Drop)] = [
        ("Title", .title),
        ("Title + Custom Duration (0.2s)", .titleWithCustomDuration),
        ("Title + subtitle", .titleSubtitle),
        ("Icon + Title + Subtitle", .titleSubtitleIcon),
        ("Title + Action", .titleAction),
        ("Title + Subtitle + Action", .titleSubtitleAction)
    ]

    private lazy var tableView: UITableView = {
        let view = UITableView(frame: self.view.frame, style: .insetGrouped)
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.dataSource = dataSource
        view.delegate = self
        return view
    }()

    private var dataSource: DataSource!
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let drop = drops[indexPath.row].drop
        switch drop {
        case .titleWithCustomDuration:
            present(drop: drop, duration: 0.2)
        default:
            present(drop: drop)
        }
    }
}
