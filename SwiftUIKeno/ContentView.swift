//
//  ContentView.swift
//  SwiftUIKeno
//
//  Created by Jeffrey Kereakoglow on 8/15/23.
//

import SwiftUI
import ComposableArchitecture

// Connor's additions
/*
struct PinnedFooter<FooterContent: View>: ViewModifier {
    
    let footerContent = () -> FooterContent
    
    func body(content: Content) -> some View {
        VStack {
            content
            Spacer()
            footerContent()
        }
    }
}

extension View {
    func kenoTextStyle() -> some View {
        self.modifier(KenoTextViewModifier())
    }
    
    func pinnedFooter(footerContent: () -> some View) -> some View {
        self.modifier(PinnedFooter(footercontent))
    }
}
 
 extension Text {
     func bonusTextStyle() -> some View {
         self.modifier(BonusTextViewModifier())
     }
 }
*/

@Reducer
struct CounterFeature {
    
    @ObservableState
    struct State: Equatable {
        enum Bonus: CaseIterable {
            case bonus(UInt)
            case none
            
            var title: String {
                switch self {
                case .bonus(let b):
                    return "Bonus = \(b)"
                case .none:
                    return "No bonus"
                }
            }
        }
        
        var numbers = [UInt]()
        var bonus = Bonus.none
    }
    
    enum Action: Equatable {
        case numberButtonTapped(UInt)
    }
    
    // You can also use `ReducerOf<Self>`
    var body: some Reducer<State, Action> {
        // The first responsibility of the Reducer is to mutate the state to the "next state"
        Reduce { state, action in
            switch action {
            case .numberButtonTapped(let number):
                print("tapped")
                
                return .none
            }
        }
    }
}

struct TitleViewModifier: ViewModifier {
    let color: Color
    
    init(color: Color = Color("White")) {
        self.color = color
    }
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 24, weight: .heavy, design: .rounded))
            .foregroundColor(color)
    }
}

struct NumberButtonStyle: ButtonStyle {
    let width: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        let shape = RoundedRectangle(cornerRadius: 12)
        let backgroundColor = Color("Maroon")
        let foregroundColor = Color("OffWhite")
        
        configuration.label
            .frame(width: width, height: width)
            .padding()
            .background(shape.stroke(lineWidth: 8).fill(foregroundColor))
            .background(backgroundColor)
            .foregroundStyle(foregroundColor)
            .clipShape(shape)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2),value: configuration.isPressed)
    }
}

struct Background: View {
    var body: some View {
        
        Rectangle()
            .fill(Gradient(colors: [Color("DarkBlue"), Color("LightBlue")]))
            .ignoresSafeArea()
    }
}

struct NumberCell: View {
    let cellSize: CGSize
    let store: Store<CounterFeature.State, CounterFeature.Action>
    
    private let number: UInt
    @State private var showModal = false
    
    init(cellSize: CGSize, index: (Int, Int), store: Store<CounterFeature.State, CounterFeature.Action>, showModal: Bool = false) {
        self.cellSize = cellSize
        self.store = store
        
        let numberIndex: Int
        switch index {
        case (0, 0):
            numberIndex = 0
        case (0, _):
            numberIndex = index.1
        case (_, 0):
            numberIndex = index.0
        default:
            numberIndex = index.0 * index.1
        }
        
        number = store.numbers[numberIndex]
    }
    
    var body: some View {
        Button(action: { select(number: number) }) {
            Text("\(number)").modifier(TitleViewModifier())
        }
        .buttonStyle(NumberButtonStyle(width: floor(cellSize.width / 2)))
        .sheet(isPresented: $showModal) {
            ZStack {
                Background()
                Text("\(number)").modifier(TitleViewModifier())
            }
        }
    }
    
    func select(number: UInt) {
        showModal = true
        store.send(.numberButtonTapped(number))
    }
}

struct NumberGrid: View {
    let geometry: GeometryProxy
    let cellSize: CGSize
    let store: Store<CounterFeature.State, CounterFeature.Action>
    
    init(geometry: GeometryProxy, store: Store<CounterFeature.State, CounterFeature.Action>) {
        let size = floor((geometry.size.width / 4) - 16)
        
        self.geometry = geometry
        cellSize = .init(width: size, height: size)
    }
    
    var body: some View {
        Grid {
            ForEach(0..<5) { row in
                GridRow {
                    ForEach(0..<4) { col in
                        NumberCell(
                            cellSize: cellSize, 
                            index: (row, col),
                            store: store
                        )
                    }
                }
            }
        }
    }
}

struct GameButton: View {
    let text: String
    
    @State private var showModal = false
    
    var body: some View {
        Button(action: { showModal = true }) {
            Text(text).modifier(TitleViewModifier())
        }.sheet(isPresented: $showModal) {
            List {
                ForEach(1..<10) { i in
                    Text("Game \(i)")
                        .modifier(TitleViewModifier())
                        .listRowBackground(Color.clear)
                }
            }
            .background(Background().edgesIgnoringSafeArea(.all))
                .scrollContentBackground(.hidden)
                
        }
    }
    
}

struct ContentView: View {
    // You can also express this as `StoreOf<CounterFeature>`
    let store: Store<CounterFeature.State, CounterFeature.Action>
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Background()
                VStack {
                    Image("Keno")
                    GameButton(text: viewModel.title)
                    NumberGrid(
                        geometry: geometry,
                        store: store
                    )
                    HStack {
                        Text(viewModel.gameDate).modifier(TitleViewModifier())
                        Spacer()
                        
                        Text(store.bonus.title.uppercased()).modifier(
                            TitleViewModifier(color: Color("Gold"))
                        )
                    }
                }
                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: GameViewModel(game: Game.game))
    }
}
