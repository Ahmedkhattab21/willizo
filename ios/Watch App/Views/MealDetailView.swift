import SwiftUI

struct MealDetailView: View {
  @ObservedObject var viewModel: WorkoutViewModel
  let recipe: WatchRecipeSummary

  private var detail: WatchRecipeDetail? {
    viewModel.recipeDetails[recipe.slug]
  }

  var body: some View {
    ScrollView {
      if let detail {
        MealDetailCanvas(height: canvasHeight(for: detail)) {
          MealDetailContent(detail: detail)
        }
      } else if viewModel.loadingRecipeSlug == recipe.slug {
        ProgressView()
          .tint(MealDetailTheme.lime)
          .frame(maxWidth: .infinity)
          .padding(.top, 80)
      } else {
        VStack(spacing: 8) {
          Image(systemName: "fork.knife")
            .foregroundStyle(MealDetailTheme.lime)
          Text(viewModel.recipeDetailMessage ?? "Could not load meal details")
            .font(.system(size: 7, weight: .medium))
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
          Button {
            Task { await viewModel.loadRecipeDetail(slug: recipe.slug, forceRefresh: true) }
          } label: {
            Image(systemName: "arrow.clockwise")
          }
          .accessibilityLabel("Retry meal details")
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.top, 55)
      }
    }
    .background(MealDetailTheme.background.ignoresSafeArea())
    .dynamicTypeSize(.xSmall ... .medium)
    .task { await viewModel.loadRecipeDetail(slug: recipe.slug) }
    .refreshable {
      await viewModel.loadRecipeDetail(slug: recipe.slug, forceRefresh: true)
    }
  }

  private func canvasHeight(for detail: WatchRecipeDetail) -> CGFloat {
    max(299, 207 + CGFloat(detail.ingredients.count) * 18)
  }
}

private struct MealDetailContent: View {
  let detail: WatchRecipeDetail

  var body: some View {
    ZStack(alignment: .topLeading) {
      MealDetailTheme.background

      headerImage
        .frame(width: 184, height: 99)
        .clipped()

      LinearGradient(
        colors: [.clear, MealDetailTheme.background.opacity(0.9), MealDetailTheme.background],
        startPoint: .top,
        endPoint: .bottom
      )
      .frame(width: 184, height: 66)
      .position(x: 92, y: 72)

      Text(detail.name)
        .font(.system(size: 9, weight: .bold))
        .foregroundStyle(.white)
        .lineLimit(1)
        .minimumScaleFactor(0.65)
        .frame(width: 164, alignment: .leading)
        .position(x: 92, y: 58)

      (Text(bestTime).foregroundColor(MealDetailTheme.lightText)
        + Text("  •  ").foregroundColor(MealDetailTheme.lightText)
        + Text("♨ \(calories) Kcal").foregroundColor(MealDetailTheme.orange))
        .font(.system(size: 6.5, weight: .regular))
        .lineLimit(1)
        .frame(width: 164, alignment: .leading)
        .position(x: 92, y: 74)

      nutritionCard(
        x: 48,
        y: 108,
        title: "Protein",
        value: grams(detail.nutrition.protein),
        tint: MealDetailTheme.protein,
        background: MealDetailTheme.proteinBackground
      )
      nutritionCard(
        x: 136,
        y: 108,
        title: "Carbs",
        value: grams(detail.nutrition.carbs),
        tint: MealDetailTheme.orange,
        background: MealDetailTheme.carbsBackground
      )
      nutritionCard(
        x: 48,
        y: 154,
        title: "Fat",
        value: grams(detail.nutrition.fat),
        tint: MealDetailTheme.fat,
        background: MealDetailTheme.fatBackground
      )
      nutritionCard(
        x: 136,
        y: 154,
        title: "Fiber",
        value: grams(detail.nutrition.fiber),
        tint: MealDetailTheme.lightText,
        background: MealDetailTheme.fiberBackground
      )

      Text("INGREDIENTS")
        .font(.system(size: 6.5, weight: .regular))
        .foregroundStyle(MealDetailTheme.muted)
        .frame(width: 164, alignment: .leading)
        .position(x: 92, y: 186)

      VStack(alignment: .leading, spacing: 0) {
        ForEach(detail.ingredients.sorted(by: { $0.order < $1.order })) { ingredient in
          HStack(spacing: 5) {
            Circle()
              .fill(MealDetailTheme.lime)
              .frame(width: 2, height: 2)
            Text(ingredient.name)
              .font(.system(size: 6.5, weight: .regular))
              .foregroundStyle(MealDetailTheme.lightText)
              .lineLimit(1)
            Spacer(minLength: 0)
          }
          .frame(width: 164, height: 18)
        }
      }
      .padding(.leading, 10)
      .padding(.top, 198)
    }
  }

  private var bestTime: String {
    let value = detail.bestTimeToEat?.split(separator: ",").first.map(String.init) ?? "--"
    return value.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  private var calories: String {
    detail.nutrition.calories.map(String.init) ?? "--"
  }

  private func grams(_ value: Double?) -> String {
    guard let value else { return "--g" }
    return value.rounded() == value ? "\(Int(value))g" : "\(value.formatted())g"
  }

  private func nutritionCard(
    x: CGFloat,
    y: CGFloat,
    title: String,
    value: String,
    tint: Color,
    background: Color
  ) -> some View {
    VStack(alignment: .leading, spacing: 3) {
      Text(title)
        .font(.system(size: 8, weight: .semibold))
        .foregroundStyle(tint)
      Text(value)
        .font(.system(size: 7, weight: .bold))
        .foregroundStyle(.white)
    }
    .frame(width: 64, alignment: .leading)
    .padding(.horizontal, 8)
    .frame(width: 80, height: 42, alignment: .leading)
    .background(background, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    .position(x: x, y: y)
  }

  @ViewBuilder
  private var headerImage: some View {
    AsyncImage(url: resolvedImageURL) { phase in
      switch phase {
      case .success(let image):
        image
          .resizable()
          .scaledToFill()
      default:
        ZStack {
          MealDetailTheme.fiberBackground
          Image(systemName: "fork.knife")
            .font(.system(size: 20, weight: .semibold))
            .foregroundStyle(MealDetailTheme.lime)
        }
      }
    }
  }

  private var resolvedImageURL: URL? {
    guard let imageURL = detail.imageURL, !imageURL.isEmpty else { return nil }
    if let absoluteURL = URL(string: imageURL), absoluteURL.scheme != nil {
      return absoluteURL
    }
    return URL(string: "https://willizo.com" + (imageURL.hasPrefix("/") ? imageURL : "/\(imageURL)"))
  }
}

private struct MealDetailCanvas<Content: View>: View {
  let height: CGFloat
  let content: Content

  init(height: CGFloat, @ViewBuilder content: () -> Content) {
    self.height = height
    self.content = content()
  }

  var body: some View {
    GeometryReader { geometry in
      let scale = min(geometry.size.width / 184, 1)
      content
        .frame(width: 184, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .scaleEffect(scale, anchor: .top)
        .frame(width: geometry.size.width, height: height * scale, alignment: .top)
    }
    .frame(height: height)
  }
}

private enum MealDetailTheme {
  static let lime = Color(red: 212 / 255, green: 1, blue: 0)
  static let background = Color(red: 15 / 255, green: 15 / 255, blue: 15 / 255)
  static let muted = Color(red: 161 / 255, green: 161 / 255, blue: 170 / 255)
  static let lightText = Color(red: 209 / 255, green: 213 / 255, blue: 219 / 255)
  static let orange = Color(red: 251 / 255, green: 146 / 255, blue: 60 / 255)
  static let protein = Color(red: 45 / 255, green: 212 / 255, blue: 191 / 255)
  static let fat = Color(red: 192 / 255, green: 132 / 255, blue: 252 / 255)
  static let proteinBackground = Color(red: 33 / 255, green: 66 / 255, blue: 62 / 255)
  static let carbsBackground = Color(red: 74 / 255, green: 53 / 255, blue: 36 / 255)
  static let fatBackground = Color(red: 62 / 255, green: 50 / 255, blue: 74 / 255)
  static let fiberBackground = Color(red: 42 / 255, green: 47 / 255, blue: 55 / 255)
}
