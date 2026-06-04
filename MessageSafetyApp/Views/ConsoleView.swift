import SwiftUI

struct ConsoleView: View {
    @EnvironmentObject var logger: MessageLogger
    @State private var showExplanation = false
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "eye.fill")
                            .foregroundColor(.red)
                        Text("ВОТ ЧТО ВИДИТ СЕРВЕР:")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                    
                    Text("Каждое сообщение и фото, которое ты отправляешь, записывается здесь. Это видят: компания-разработчик, рекламодатели, администраторы, а иногда и кто-то ещё.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.yellow.opacity(0.1))
                
                ScrollView {
                    Text(logger.consoleOutput)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
                .background(Color.black)
                .cornerRadius(8)
                .padding()
            }
            .navigationTitle("🔍 Логи сервера")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
