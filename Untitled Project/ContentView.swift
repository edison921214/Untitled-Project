import SwiftUI
import Foundation
struct ContentView: View {
    var body: some View {
        NavigationStack {
            DanceStyleSelectionView()
                .navigationDestination(for: DanceStyle.self) { style in
                    DifficultySelectionView(style: style)
                }
                .navigationDestination(for: TrainingSelection.self) { selection in
                    TrainingMenuView(
                        style: selection.style,
                        difficulty: selection.difficulty
                    )
                }
        }
        .font(.biauKai(.body, size: 17))
        .preferredColorScheme(.dark)
    }
}

private struct DanceStyleSelectionView: View {
    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 26) {
                    header

                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(DanceStyle.allCases) { style in
                            NavigationLink(value: style) {
                                DanceStyleCard(style: style)
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    Text("每套課程約 60 分鐘，從基礎、控制到音樂應用，一步一步建立你的舞感。")
                        .font(.biauKai(.footnote, size: 13))
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 2)
                }
                .padding(.horizontal, 20)
                .padding(.top, 28)
                .padding(.bottom, 36)
            }
            .scrollIndicators(.hidden)
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("START YOUR GROOVE")
                .font(.biauKai(.caption, size: 12, weight: .bold))
                .tracking(2.4)
                .foregroundStyle(Color(red: 0.79, green: 1.0, blue: 0.18))

            Text("這就是過程")
                .font(.biauKai(.largeTitle, size: 34, weight: .bold))

            Text("選擇舞風，開始你的基礎訓練")
                .font(.biauKai(.title3, size: 20))
                .foregroundStyle(.secondary)
        }
    }
}

private struct DanceStyleCard: View {
    let style: DanceStyle

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Image(systemName: style.symbol)
                    .font(.biauKai(.title2, size: 22))
                    .foregroundStyle(.black)
                    .frame(width: 48, height: 48)
                    .background(style.accentColor, in: Circle())
                    .accessibilityHidden(true)

                Spacer()

                Image(systemName: "arrow.up.right")
                    .font(.biauKai(.caption, size: 12, weight: .bold))
                    .foregroundStyle(style.accentColor)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(style.title)
                    .font(.biauKai(.title3, size: 20, weight: .bold))
                    .foregroundStyle(.primary)

                Text(style.subtitle)
                    .font(.biauKai(.caption, size: 12))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 132, alignment: .leading)
        .padding(16)
        .background(
            LinearGradient(
                colors: [style.accentColor.opacity(0.16), Color.white.opacity(0.06)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 24, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(style.accentColor.opacity(0.22), lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
        .accessibilityHint("開啟基礎訓練菜單")
    }
}

private struct DifficultySelectionView: View {
    let style: DanceStyle

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(style.title.uppercased())
                            .font(.biauKai(.caption, size: 12, weight: .bold))
                            .tracking(2.4)
                            .foregroundStyle(style.accentColor)

                        Text("選擇訓練難度")
                            .font(.biauKai(.largeTitle, size: 34, weight: .bold))

                        Text("依照目前程度選擇，循序建立穩定的動作與舞感。")
                            .font(.biauKai(.subheadline, size: 15))
                            .foregroundStyle(.secondary)
                    }

                    VStack(spacing: 14) {
                        ForEach(TrainingDifficulty.allCases) { difficulty in
                            NavigationLink(
                                value: TrainingSelection(
                                    style: style,
                                    difficulty: difficulty
                                )
                            ) {
                                DifficultyCard(
                                    difficulty: difficulty,
                                    accentColor: style.accentColor
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(20)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle(style.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
    }
}

private struct DifficultyCard: View {
    let difficulty: TrainingDifficulty
    let accentColor: Color

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: difficulty.symbol)
                .font(.biauKai(.title2, size: 22))
                .foregroundStyle(.black)
                .frame(width: 52, height: 52)
                .background(accentColor, in: RoundedRectangle(cornerRadius: 16))

            VStack(alignment: .leading, spacing: 5) {
                Text(difficulty.title)
                    .font(.biauKai(.title3, size: 20, weight: .bold))

                Text(difficulty.description)
                    .font(.biauKai(.subheadline, size: 15))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.biauKai(.subheadline, size: 15, weight: .bold))
                .foregroundStyle(accentColor)
        }
        .padding(18)
        .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 22))
        .overlay {
            RoundedRectangle(cornerRadius: 22)
                .stroke(accentColor.opacity(0.18), lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
        .accessibilityHint("開啟訓練內容")
    }
}

private struct TrainingMenuView: View {
    let style: DanceStyle
    let difficulty: TrainingDifficulty

    @State private var completedExerciseIDs: Set<String> = []

    private var exercises: [DanceExercise] {
        DanceExercise.exercises(for: style, difficulty: difficulty)
    }

    private var accentColor: Color {
        style.accentColor
    }

    private var completedMinutes: Int {
        exercises
            .filter { completedExerciseIDs.contains($0.id) }
            .reduce(0) { $0 + $1.duration }
    }

    private var totalMinutes: Int {
        exercises.reduce(0) { $0 + $1.duration }
    }

    private var progress: Double {
        guard !exercises.isEmpty else { return 0 }
        return Double(completedExerciseIDs.count) / Double(exercises.count)
    }

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            ScrollView {
                LazyVStack(spacing: 24) {
                    header
                    heroImage
                    weeklySchedule
                    progressCard
                    trainingSection
                    learningResources
                    coachTip
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 36)
            }
            .scrollIndicators(.hidden)
        }
        .preferredColorScheme(.dark)
        .navigationTitle("\(style.title) · \(difficulty.title)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text(style.englishTitle.uppercased())
                    .font(.biauKai(.caption, size: 12, weight: .bold))
                    .tracking(2.4)
                    .foregroundStyle(accentColor)

                Text("\(style.title) · \(difficulty.title)")
                    .font(.biauKai(.largeTitle, size: 34, weight: .bold))

                Text(style.slogan(for: difficulty))
                    .font(.biauKai(.headline, size: 17))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            Image(systemName: "figure.dance")
                .font(.biauKai(.title2, size: 22))
                .foregroundStyle(.black)
                .frame(width: 48, height: 48)
                .background(accentColor, in: Circle())
                .accessibilityHidden(true)
        }
        .padding(.top, 18)
    }

    private var heroImage: some View {
        ZStack(alignment: .bottomLeading) {
            Image(style.heroImageName)
                .resizable()
                .scaledToFill()
                .frame(height: 210)
                .frame(maxWidth: .infinity)
                .clipped()

            LinearGradient(
                colors: [.clear, .black.opacity(0.78)],
                startPoint: .center,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 4) {
                Text("60 MIN TRAINING")
                    .font(.biauKai(.caption, size: 12, weight: .bold))
                    .tracking(1.6)
                    .foregroundStyle(accentColor)

                Text(style.subtitle)
                    .font(.biauKai(.headline, size: 17))
                    .foregroundStyle(.white)
            }
            .padding(18)
        }
        .frame(height: 210)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(style.title) 舞風訓練照片")
    }

    private var weeklySchedule: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("本週節奏")
                .font(.biauKai(.headline, size: 17))

            HStack(spacing: 8) {
                ForEach(TrainingDay.currentWeek) { day in
                    VStack(spacing: 8) {
                        Text(day.weekday)
                            .font(.biauKai(.caption, size: 12))
                            .foregroundStyle(day.isToday ? .black : .secondary)

                        Text(day.date)
                            .font(.biauKai(.headline, size: 17))
                            .foregroundStyle(day.isToday ? .black : .white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        day.isToday ? accentColor : Color.white.opacity(0.08),
                        in: RoundedRectangle(cornerRadius: 16, style: .continuous)
                    )
                }
            }
        }
    }

    private var progressCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("今日訓練")
                        .font(.biauKai(.title3, size: 20, weight: .bold))

                    Text("建立節奏感，比追求速度更重要")
                        .font(.biauKai(.subheadline, size: 15))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text("\(completedMinutes) / \(totalMinutes) 分")
                    .font(.biauKai(.subheadline, size: 15, weight: .semibold))
                    .foregroundStyle(accentColor)
            }

            ProgressView(value: progress)
                .tint(accentColor)
                .scaleEffect(x: 1, y: 1.8)
                .accessibilityLabel("今日訓練進度")
                .accessibilityValue("\(Int(progress * 100))%")

            HStack {
                Label(difficulty.title, systemImage: "sparkles")
                Spacer()
                Label("不需器材", systemImage: "figure.strengthtraining.traditional")
                Spacer()
                Label("約 \(totalMinutes) 分", systemImage: "clock")
            }
            .font(.biauKai(.caption, size: 12, weight: .medium))
            .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color.white.opacity(0.14), Color.white.opacity(0.06)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 24, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        }
    }

    private var trainingSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("訓練菜單")
                    .font(.biauKai(.title2, size: 22, weight: .bold))

                Spacer()

                Text("\(completedExerciseIDs.count)/\(exercises.count) 完成")
                    .font(.biauKai(.caption, size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
            }

            ForEach(exercises) { exercise in
                ExerciseCard(
                    exercise: exercise,
                    style: style,
                    difficulty: difficulty,
                    isCompleted: completedExerciseIDs.contains(exercise.id),
                    accentColor: accentColor
                ) {
                    withAnimation(.snappy) {
                        if completedExerciseIDs.contains(exercise.id) {
                            completedExerciseIDs.remove(exercise.id)
                        } else {
                            completedExerciseIDs.insert(exercise.id)
                        }
                    }
                }
            }
        }
    }

    private var learningResources: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("延伸學習")
                .font(.biauKai(.title2, size: 22, weight: .bold))

            if let spotifyURL = style.spotifyPlaylistURL {
                Link(destination: spotifyURL) {
                    resourceCard(
                        title: style.spotifyPlaylistTitle,
                        subtitle: style.playlistDescription,
                        symbol: "music.note.list",
                        action: "Spotify"
                    )
                }
                .buttonStyle(.plain)
            }

            Text("推薦舞蹈教室")
                .font(.biauKai(.headline, size: 17))
                .padding(.top, 8)

            ForEach(StudioRecommendation.recommendations(for: style)) { studio in
                if let url = studio.url {
                    Link(destination: url) {
                        resourceCard(
                            title: studio.name,
                            subtitle: "\(studio.specialty) · \(studio.location)",
                            symbol: "figure.dance",
                            action: "查看資訊"
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func resourceCard(
        title: String,
        subtitle: String,
        symbol: String,
        action: String
    ) -> some View {
        HStack(spacing: 14) {
            Image(systemName: symbol)
                .font(.biauKai(.title2, size: 22))
                .foregroundStyle(.black)
                .frame(width: 50, height: 50)
                .background(accentColor, in: RoundedRectangle(cornerRadius: 15))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.biauKai(.headline, size: 17))
                    .foregroundStyle(.primary)

                Text(subtitle)
                    .font(.biauKai(.caption, size: 12))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Image(systemName: "arrow.up.right")
                Text(action)
                    .font(.biauKai(.caption2, size: 11))
            }
            .foregroundStyle(accentColor)
        }
        .padding(16)
        .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 22))
    }

    private var coachTip: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: "lightbulb.max.fill")
                .font(.biauKai(.title3, size: 20))
                .foregroundStyle(accentColor)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 5) {
                Text("教練提醒")
                    .font(.biauKai(.headline, size: 17))

                Text("先用 70% 的速度練穩拍點。動作清楚、重心到位後，再跟著音樂逐步加速。")
                    .font(.biauKai(.subheadline, size: 15))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(18)
        .background(Color.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 20))
    }
}

private struct ExerciseDetailView: View {
    let exercise: DanceExercise
    let style: DanceStyle
    let difficulty: TrainingDifficulty

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("\(exercise.category) · \(exercise.duration) 分鐘", systemImage: exercise.symbol)
                            .font(.biauKai(.subheadline, size: 15, weight: .bold))
                            .foregroundStyle(style.accentColor)

                        Text(exercise.title)
                            .font(.biauKai(.largeTitle, size: 34, weight: .bold))

                        Text(exercise.detail)
                            .font(.biauKai(.title3, size: 20))
                            .foregroundStyle(.secondary)
                    }

                    learningSection(
                        title: "練習目標",
                        symbol: "target",
                        content: exercise.learningGoal
                    )

                    VStack(alignment: .leading, spacing: 14) {
                        Label("動作分解", systemImage: "list.number")
                            .font(.biauKai(.title3, size: 20, weight: .bold))
                            .foregroundStyle(style.accentColor)

                        ForEach(Array(exercise.learningSteps.enumerated()), id: \.offset) { index, step in
                            HStack(alignment: .top, spacing: 12) {
                                Text("\(index + 1)")
                                    .font(.biauKai(.caption, size: 12, weight: .bold))
                                    .foregroundStyle(.black)
                                    .frame(width: 26, height: 26)
                                    .background(style.accentColor, in: Circle())

                                Text(step)
                                    .font(.biauKai(.body, size: 17))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .padding(18)
                    .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 22))

                    learningSection(
                        title: "常見錯誤",
                        symbol: "exclamationmark.triangle.fill",
                        content: exercise.commonMistake
                    )

                    learningSection(
                        title: "\(difficulty.title)練習提示",
                        symbol: "lightbulb.max.fill",
                        content: difficulty.detailTip
                    )
                }
                .padding(20)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle(exercise.category)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func learningSection(
        title: String,
        symbol: String,
        content: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: symbol)
                .font(.biauKai(.headline, size: 17))
                .foregroundStyle(style.accentColor)

            Text(content)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 22))
    }
}

private struct ExerciseCard: View {
    let exercise: DanceExercise
    let style: DanceStyle
    let difficulty: TrainingDifficulty
    let isCompleted: Bool
    let accentColor: Color
    let toggleCompletion: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            NavigationLink {
                ExerciseDetailView(
                    exercise: exercise,
                    style: style,
                    difficulty: difficulty
                )
            } label: {
                HStack(spacing: 16) {
                    Image(systemName: exercise.symbol)
                        .font(.biauKai(.title2, size: 22))
                        .foregroundStyle(accentColor)
                        .frame(width: 50, height: 50)
                        .background(
                            accentColor.opacity(0.12),
                            in: RoundedRectangle(cornerRadius: 16, style: .continuous)
                        )

                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(exercise.category) · \(exercise.duration) 分鐘")
                            .font(.biauKai(.caption, size: 12, weight: .bold))
                            .foregroundStyle(accentColor)

                        Text(exercise.title)
                            .font(.biauKai(.headline, size: 17))
                            .foregroundStyle(isCompleted ? .secondary : .primary)
                            .strikethrough(isCompleted)

                        Text(exercise.detail)
                            .font(.biauKai(.caption, size: 12))
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }

                    Spacer(minLength: 4)

                    Image(systemName: "chevron.right")
                        .font(.biauKai(.caption, size: 12, weight: .bold))
                        .foregroundStyle(.secondary)
                }
            }
            .buttonStyle(.plain)
            .accessibilityHint("開啟動作分解與練習提示")

            Button(action: toggleCompletion) {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.biauKai(.title2, size: 22))
                    .foregroundStyle(isCompleted ? accentColor : Color.white.opacity(0.25))
                    .frame(width: 36, height: 44)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isCompleted ? "標示為未完成" : "標示為已完成")
        }
        .padding(16)
        .background(Color.white.opacity(isCompleted ? 0.04 : 0.08))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

private struct DanceExercise: Identifiable {
    let id: String
    let category: String
    let title: String
    let detail: String
    let duration: Int
    let symbol: String

    var learningGoal: String {
        switch id {
        case "warm-up": "提高關節活動度與核心溫度，讓後續動作更安全、更有彈性。"
        case "rhythm": "讓拍點進入身體，維持穩定重心，不只用耳朵追音樂。"
        case "foundation-a", "foundation-b": "建立清楚的動作路徑與正確發力順序，再逐步提升速度。"
        case "practice-method": "控制動作開始、經過與停止的位置，做出一致的質感。"
        case "combination": "在不中斷律動的前提下，記住順序並完成方向轉換。"
        case "musicality": "辨認音樂中的鼓點、旋律與留白，做出不同層次。"
        case "freestyle": "主動選擇已學元素回應音樂，培養個人表達。"
        default: "放慢呼吸與心率，舒緩緊繃肌群並回顧訓練。"
        }
    }

    var learningSteps: [String] {
        switch id {
        case "warm-up":
            ["小幅度轉動肩頸與手腕。", "依序活動胸椎、髖與膝蓋。", "用輕 Bounce 或小跑步提高體溫。"]
        case "rhythm":
            ["先用腳或點頭確認重拍。", "加入膝蓋與重心的連續彈性。", "更換速度，保持動作幅度一致。"]
        case "foundation-a", "foundation-b":
            ["不放音樂，慢速確認起點和終點。", "左右各重複四組八拍。", "加入音樂，從 60% 速度逐步加快。"]
        case "practice-method":
            ["選一個部位單獨練習。", "用四拍完成，再縮短成兩拍與一拍。", "錄影比較每次角度與力量是否一致。"]
        case "combination":
            ["把組合拆成每兩拍一段。", "連接成一組八拍並保持律動。", "加入方向、表情與音樂層次。"]
        case "musicality":
            ["第一輪只跟鼓點。", "第二輪改跟旋律或歌聲。", "第三輪運用停頓回應空拍。"]
        case "freestyle":
            ["先限定只使用三個動作。", "每兩組八拍更換一個元素。", "最後一輪不預想順序，直接回應音樂。"]
        default:
            ["降低動作速度並深呼吸。", "每個伸展維持二十至三十秒。", "記錄今天最穩定與需要加強的項目。"]
        }
    }

    var commonMistake: String {
        switch id {
        case "warm-up": "不要快速甩動關節或一開始就拉到極限；暖身應逐步增加幅度。"
        case "rhythm": "只動四肢、核心僵硬會讓律動中斷；先保持重心連續再加動作。"
        case "foundation-a", "foundation-b": "急著跟原速音樂容易省略路徑；角度清楚比速度更重要。"
        case "practice-method": "不要全身同時用力。先找出主要發力部位，其餘部位保持放鬆。"
        case "combination": "忘記動作時不要停下來；維持基本律動，下一拍再接回組合。"
        case "musicality": "不要每個聲音都做動作。選一個音樂層次，留白也屬於表現。"
        case "freestyle": "不要一直尋找新動作；重複熟悉元素並改變大小、方向就能產生變化。"
        default: "伸展不應造成尖銳疼痛；保持自然呼吸，不要用彈震方式壓低身體。"
        }
    }

    static func exercises(
        for style: DanceStyle,
        difficulty: TrainingDifficulty
    ) -> [DanceExercise] {
        [
            DanceExercise(
                id: "warm-up",
                category: "暖身",
                title: "全身動態熱身",
                detail: "活動肩頸、胸椎、髖與腳踝，準備進入 \(style.title) 訓練",
                duration: 7,
                symbol: "figure.flexibility"
            ),
            DanceExercise(
                id: "rhythm",
                category: "律動",
                title: style.rhythmName,
                detail: "跟著四種速度找拍點，維持呼吸與重心連續",
                duration: 8,
                symbol: "metronome.fill"
            ),
            DanceExercise(
                id: "foundation-a",
                category: "基礎 A",
                title: style.foundationName,
                detail: "分解核心動作，以鏡子確認角度、方向與重心",
                duration: 8,
                symbol: style.symbol
            ),
            DanceExercise(
                id: "foundation-b",
                category: "基礎 B",
                title: style.secondaryFoundationName,
                detail: "左右各練四組八拍，再加入行進與方向變化",
                duration: 8,
                symbol: "arrow.left.and.right"
            ),
            DanceExercise(
                id: "practice-method",
                category: "控制",
                title: "動作質感練習",
                detail: style.practiceMethod,
                duration: 8,
                symbol: "scope"
            ),
            DanceExercise(
                id: "combination",
                category: difficulty.title,
                title: "\(difficulty.title)組合訓練",
                detail: difficulty.combinationDescription,
                duration: 8,
                symbol: "repeat"
            ),
            DanceExercise(
                id: "musicality",
                category: "音樂性",
                title: "拍點與層次變化",
                detail: "分別跟隨鼓點、旋律與空拍，練習三種表現方式",
                duration: 6,
                symbol: "waveform"
            ),
            DanceExercise(
                id: "freestyle",
                category: "整合",
                title: "自由練習",
                detail: "用今天的三個元素完成一輪不間斷即興",
                duration: 4,
                symbol: "music.note"
            ),
            DanceExercise(
                id: "cool-down",
                category: "收操",
                title: "呼吸與靜態伸展",
                detail: "放鬆主要使用的肌群，記錄今天最穩定的動作",
                duration: 3,
                symbol: "wind"
            )
        ]
    }

    static let sampleExercises = [
        DanceExercise(
            id: "warm-up",
            category: "暖身",
            title: "全身動態熱身",
            detail: "肩頸、胸椎、髖與腳踝依序活動",
            duration: 5,
            symbol: "figure.flexibility"
        ),
        DanceExercise(
            id: "bounce-rock",
            category: "律動",
            title: "Bounce ＆ Rock",
            detail: "每個動作 8 拍，練習上下與前後重心",
            duration: 8,
            symbol: "waveform.path.ecg"
        ),
        DanceExercise(
            id: "basic-steps",
            category: "腳步",
            title: "Two Step ＆ Step Touch",
            detail: "保持膝蓋彈性，讓腳步和上身自然連動",
            duration: 8,
            symbol: "shoeprints.fill"
        ),
        DanceExercise(
            id: "isolation",
            category: "控制",
            title: "胸、肩、髖 Isolation",
            detail: "分離身體部位，慢速完成四個方向",
            duration: 7,
            symbol: "figure.mind.and.body"
        ),
        DanceExercise(
            id: "freestyle",
            category: "整合",
            title: "一首歌自由組合",
            detail: "運用今天的律動與腳步完成 2 組 8 拍",
            duration: 7,
            symbol: "music.note"
        ),
        DanceExercise(
            id: "cool-down",
            category: "收操",
            title: "呼吸與靜態伸展",
            detail: "放鬆腿後側、髖屈肌、背部與肩膀",
            duration: 5,
            symbol: "wind"
        )
    ]
}

private struct StudioRecommendation: Identifiable {
    let name: String
    let specialty: String
    let location: String
    let url: URL?

    var id: String { name }

    static func recommendations(for style: DanceStyle) -> [StudioRecommendation] {
        let hrc = StudioRecommendation(
            name: "HRC Dance Studio",
            specialty: "多舞風分級課程",
            location: "台北／新北／台中",
            url: URL(string: "https://www.hrc.com.tw/")
        )
        let boog = StudioRecommendation(
            name: "BOOG Studio／BOOG NATION",
            specialty: "Popping、Locking、Funk",
            location: "台北延吉街／新北永和",
            url: URL(string: "https://maps.apple.com/?q=BOOG%20Studio%20%E5%BB%B6%E5%90%89%E8%A1%97")
        )
        let ip = StudioRecommendation(
            name: "IP LOCKERS TRAINING SKOOL",
            specialty: "Locking 專項訓練",
            location: "台北市萬華區柳州街 80 號 3 樓",
            url: URL(string: "https://www.instagram.com/iplockers_trainingskool/")
        )

        switch style {
        case .popping:
            return [boog, hrc]
        case .locking:
            return [ip, boog, hrc]
        case .hipHop, .house, .waacking, .breaking:
            return [hrc, boog]
        }
    }
}

private struct TrainingSelection: Hashable {
    let style: DanceStyle
    let difficulty: TrainingDifficulty
}

private enum TrainingDifficulty: String, CaseIterable, Identifiable {
    case beginner
    case intermediate
    case advanced

    var id: Self { self }

    var title: String {
        switch self {
        case .beginner: "入門"
        case .intermediate: "進階"
        case .advanced: "高階"
        }
    }

    var description: String {
        switch self {
        case .beginner: "拆解基本動作，建立正確發力方式"
        case .intermediate: "串連變化，提升控制與音樂性"
        case .advanced: "加入速度、層次與即興挑戰"
        }
    }

    var symbol: String {
        switch self {
        case .beginner: "1.circle.fill"
        case .intermediate: "2.circle.fill"
        case .advanced: "3.circle.fill"
        }
    }

    var detailTip: String {
        switch self {
        case .beginner: "把速度降到能清楚控制的程度，每完成四次再小幅加速。"
        case .intermediate: "加入高低、大小與方向變化，但全程保留舞風的核心律動。"
        case .advanced: "以原速完成後更換歌曲，練習快速適應不同拍點與音樂質感。"
        }
    }

    var combinationDescription: String {
        switch self {
        case .beginner: "以兩組八拍熟悉順序，先慢速再跟原速音樂"
        case .intermediate: "加入方向、層次與轉換，完成四組八拍"
        case .advanced: "加入速度切換、即興段落與高強度連續練習"
        }
    }

    var durationAdjustment: Int {
        switch self {
        case .beginner: 0
        case .intermediate: 3
        case .advanced: 5
        }
    }
}

private enum DanceStyle: String, CaseIterable, Identifiable {
    case popping
    case locking
    case hipHop
    case house
    case waacking
    case breaking

    var id: Self { self }

    var title: String {
        switch self {
        case .popping: "Popping"
        case .locking: "Locking"
        case .hipHop: "Hip Hop"
        case .house: "House"
        case .waacking: "Waacking"
        case .breaking: "Breaking"
        }
    }

    var englishTitle: String {
        switch self {
        case .popping: "Hit & Control"
        case .locking: "Lock & Point"
        case .hipHop: "Basic Bounce"
        case .house: "Footwork Flow"
        case .waacking: "Arms & Musicality"
        case .breaking: "Toprock Basics"
        }
    }

    var subtitle: String {
        switch self {
        case .popping: "肌肉震動與身體控制"
        case .locking: "停頓、指向與 Funk 節奏"
        case .hipHop: "Bounce、Rock 與基礎步伐"
        case .house: "輕快腳步與流動重心"
        case .waacking: "手臂路徑、Pose 與音樂性"
        case .breaking: "Toprock、Footwork 與基礎體能"
        }
    }

    func slogan(for difficulty: TrainingDifficulty) -> String {
        switch (self, difficulty) {
        case (.popping, .beginner): "先學會控制身體，再讓每一下 Hit 說話。"
        case (.popping, .intermediate): "收放更精準，節奏才會真正有電。"
        case (.popping, .advanced): "控制每個瞬間，創造看得見的音樂。"
        case (.locking, .beginner): "敢停、敢笑，第一個 Lock 就有態度。"
        case (.locking, .intermediate): "鎖住拍點，放大你的 Funk 能量。"
        case (.locking, .advanced): "快慢由你掌握，每次停頓都是焦點。"
        case (.hipHop, .beginner): "先找到 Bounce，再找到自己的樣子。"
        case (.hipHop, .intermediate): "把 Groove 放進身體，讓腳步自然說話。"
        case (.hipHop, .advanced): "駕馭節奏層次，跳出只屬於你的 Flow。"
        case (.house, .beginner): "輕踩每一步，讓節奏從腳底開始。"
        case (.house, .intermediate): "腳步不停，身體依然自由流動。"
        case (.house, .advanced): "穿梭節拍之間，把速度化成從容。"
        case (.waacking, .beginner): "打開手臂，也打開你的舞台自信。"
        case (.waacking, .intermediate): "手臂畫出節奏，Pose 留下態度。"
        case (.waacking, .advanced): "速度、線條、情緒，都由你主導。"
        case (.breaking, .beginner): "站穩第一步，地板就是你的舞台。"
        case (.breaking, .intermediate): "力量接上節奏，動作才會完整。"
        case (.breaking, .advanced): "突破重力，也突破昨天的自己。"
        }
    }

    var spotifyPlaylistTitle: String {
        switch self {
        case .popping: "Popping Practice"
        case .locking: "練舞歌單 Locking"
        case .hipHop: "Hip Hop Dance Battle"
        case .house: "House Dance 練習歌單"
        case .waacking: "Funk & Disco Waacking"
        case .breaking: "Breaking Beats"
        }
    }

    var spotifyPlaylistURL: URL? {
        let urlString: String
        switch self {
        case .popping:
            urlString = "https://open.spotify.com/playlist/4vy5Ib6TQvXT8szOKYTDod"
        case .locking, .waacking:
            urlString = "https://open.spotify.com/playlist/0wnMnWZIy7LgjofgEOUd6M"
        case .hipHop:
            urlString = "https://open.spotify.com/playlist/61bsMIz5HaCOKKY99t0Ytk"
        case .house:
            urlString = "https://open.spotify.com/playlist/5aayMvcIipT1RQoLT4Ypk8"
        case .breaking:
            urlString = "https://open.spotify.com/playlist/0IHmgel0lqcNDTQt1RbaU7"
        }
        return URL(string: urlString)
    }

    var playlistDescription: String {
        switch self {
        case .popping: "Funk 與清楚重拍，適合練習 Hit 和控制"
        case .locking: "經典 Funk 節奏，適合練習 Bounce 與停頓"
        case .hipHop: "Boom Bap 與中速節拍，適合建立 Groove"
        case .house: "穩定四拍電子節奏，適合連續 Footwork"
        case .waacking: "Disco 與 Soul，適合手臂路徑和 Pose"
        case .breaking: "Breakbeat 與 Funk，適合 Toprock 和 Footwork"
        }
    }

    var heroImageName: String {
        switch self {
        case .popping: "PoppingHero"
        case .locking: "LockingHero"
        case .hipHop: "HipHopHero"
        case .house: "HouseHero"
        case .waacking: "WaackingHero"
        case .breaking: "BreakingHero"
        }
    }

    var rhythmName: String {
        switch self {
        case .popping: "Funk Groove 與重拍控制"
        case .locking: "Funk Bounce 與節奏停頓"
        case .hipHop: "Bounce、Rock 與重心轉移"
        case .house: "Jack 與連續重心流動"
        case .waacking: "Disco Groove 與胸肩律動"
        case .breaking: "Toprock Groove 與步伐節奏"
        }
    }

    var secondaryFoundationName: String {
        switch self {
        case .popping: "Wave、Roll 與 Isolation"
        case .locking: "Scooby Doo、Leo Walk 與 Pace"
        case .hipHop: "Running Man、Criss Cross 與 Skate"
        case .house: "Heel Toe、Skate 與 Loose Leg"
        case .waacking: "Whack、Overhead 與 Punking Lines"
        case .breaking: "Indian Step、CC 與 Three Step"
        }
    }

    var foundationName: String {
        switch self {
        case .popping: "Hit、Fresno 與手臂控制"
        case .locking: "Lock、Point 與 Wrist Roll"
        case .hipHop: "Bounce、Rock 與 Two Step"
        case .house: "Jack、Pas de Bourrée 與 Shuffle"
        case .waacking: "Arm Rolls、Lines 與 Pose"
        case .breaking: "Toprock、Go Down 與 Six Step"
        }
    }

    var practiceMethod: String {
        switch self {
        case .popping: "用慢拍輪流收縮手臂、胸口與腿部，再對準重拍 Hit"
        case .locking: "每個 Lock 停一拍，確認手腕、手肘與視線方向清楚"
        case .hipHop: "先固定 Bounce，再讓腳步和上半身保持同一個律動"
        case .house: "以前腳掌移動，保持身體上提並讓 Jack 持續流動"
        case .waacking: "沿頭部兩側畫出手臂路徑，配合 Pose 練習拍點"
        case .breaking: "先練穩 Toprock 重心，再分段完成 Go Down 與 Footwork"
        }
    }

    var symbol: String {
        switch self {
        case .popping: "bolt.fill"
        case .locking: "hand.point.up.left.fill"
        case .hipHop: "waveform.path.ecg"
        case .house: "shoeprints.fill"
        case .waacking: "figure.arms.open"
        case .breaking: "figure.strengthtraining.traditional"
        }
    }

    var accentColor: Color {
        switch self {
        case .popping: Color(red: 0.24, green: 0.86, blue: 1.0)
        case .locking: Color(red: 1.0, green: 0.72, blue: 0.16)
        case .hipHop: Color(red: 0.79, green: 1.0, blue: 0.18)
        case .house: Color(red: 0.55, green: 0.42, blue: 1.0)
        case .waacking: Color(red: 1.0, green: 0.46, blue: 0.75)
        case .breaking: Color(red: 1.0, green: 0.32, blue: 0.25)
        }
    }
}

private struct TrainingDay: Identifiable {
    let id: String
    let weekday: String
    let date: String
    let isToday: Bool

    static let currentWeek = [
        TrainingDay(id: "mon", weekday: "一", date: "21", isToday: false),
        TrainingDay(id: "tue", weekday: "二", date: "22", isToday: false),
        TrainingDay(id: "wed", weekday: "三", date: "23", isToday: false),
        TrainingDay(id: "thu", weekday: "四", date: "24", isToday: true),
        TrainingDay(id: "fri", weekday: "五", date: "25", isToday: false),
        TrainingDay(id: "sat", weekday: "六", date: "26", isToday: false),
        TrainingDay(id: "sun", weekday: "日", date: "27", isToday: false)
    ]
}

private extension Font {
    static func biauKai(
        _ textStyle: Font.TextStyle,
        size: CGFloat,
        weight: Font.Weight? = nil
    ) -> Font {
        let font = Font.custom(
            "BiauKai",
            size: size,
            relativeTo: textStyle
        )
        return weight.map { font.weight($0) } ?? font
    }
}

#Preview {
    ContentView()
}
