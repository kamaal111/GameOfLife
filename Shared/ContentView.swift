//
//  ContentView.swift
//  Shared
//
//  Created by Kamaal M Farah on 26/02/2022.
//

import SwiftUI
import SalmonUI
import ShrimpExtensions

struct ContentView: View {
    @StateObject private var simulation = Simulation(
        universe: .init(height: Constants.universeSize, width: Constants.universeSize))

    @State private var controlCenterSize: CGSize = .zero

    var body: some View {
        GeometryReader { geometry in
            let size = cellSize(screenSize: geometry.size)

            VStack {
                VStack {
                    HStack {
                        Button(action: { simulation.togglePlay() }) {
                            Image(systemName: simulation.isPaused ? "play.fill" : "pause.fill")
                        }
                        Button(action: { simulation.randomizeCells() }) {
                            Image(systemName: "arrow.triangle.2.circlepath")
                        }
                        Button(action: { simulation.killAllCells() }) {
                            Text("☠️")
                        }
                    }
                }
                .kBindToFrameSize($controlCenterSize)
                #if !os(macOS)
                if geometry.size.height > geometry.size.width {
                    Spacer()
                        .frame(height: geometry.size.height / 4)
                }
                #endif
                HStack {
                    #if !os(macOS)
                    if geometry.size.width > geometry.size.height {
                        Spacer()
                            .frame(width: geometry.size.width / 4)
                    }
                    #endif
                    GridStack(
                        rows: simulation.universe.height,
                        columns: simulation.universe.width,
                        spacing: Self.gridSpacing,
                        content: { x, y in
                            CellView(
                                cell: simulation.universe.getCell(x: x, y: y),
                                size: size,
                                action: { simulation.toggleCell(x: x, y: y) })
                        })
                }
            }
        }
        .padding(.all, Self.paddingSize)
        #if os(macOS)
        .frame(width: Self.screenSize.width, height: Self.screenSize.height + controlCenterSize.height)
        #endif
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                simulation.play()
            }
        })
    }

    private func cellSize(screenSize: CGSize) -> CGSize {
        #if os(macOS)
        return .squared(Self.macCellSize)
        #else
        let universeSize = CGFloat(Constants.universeSize)
        let smallestEdge = min(screenSize.width, screenSize.height)
        let size = (smallestEdge / universeSize) - Self.gridSpacing
        guard size >= 0 else { fatalError("got negative value as the smallest edge somehow") }
        return .squared(size)
        #endif
    }

    private static let gridSpacing: CGFloat = 1
    private static let paddingSize: CGFloat = 16
    #if os(macOS)
    static let macCellSize: CGFloat = 4
    static let screenSize: CGSize = .squared((CGFloat(Constants.universeSize) * (macCellSize + gridSpacing)) + (paddingSize * 2))
    #endif
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
