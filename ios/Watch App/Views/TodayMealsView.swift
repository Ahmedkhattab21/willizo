import SwiftUI

struct TodayMealsView: View {
  @ObservedObject var viewModel: WorkoutViewModel

  private var canvasHeight: CGFloat {
    max(224, 46 + CGFloat(viewModel.recipes.count) * 47)
  }

  var body: some View {
    ScrollView {
      MealsDesignCanvas(height: canvasHeight) {
        ZStack(alignment: .top) {
          MealsTheme.background

          Text("Today's meals")
            .font(.system(size: 8, weight: .bold))
            .foregroundStyle(MealsTheme.lime)
            .frame(width: 184)
            .position(x: 92, y: 19)

          content
        }
      }
    }
    .background(Color.black.ignoresSafeArea())
    .dynamicTypeSize(.xSmall ... .medium)
    .task { await viewModel.loadRecipes() }
    .refreshable { await viewModel.loadRecipes(forceRefresh: true) }
  }

  @ViewBuilder
  private var content: some View {
    if viewModel.isLoadingRecipes && viewModel.recipes.isEmpty {
      ProgressView()
        .tint(MealsTheme.lime)
        .position(x: 92, y: 112)
    } else if viewModel.recipes.isEmpty {
      VStack(spacing: 7) {
        Image(systemName: "fork.knife")
          .foregroundStyle(MealsTheme.lime)
        Text(viewModel.recipesMessage ?? "No meals available")
          .font(.system(size: 7, weight: .medium))
          .foregroundStyle(MealsTheme.muted)
          .multilineTextAlignment(.center)
      }
      .frame(width: 145)
      .position(x: 92, y: 112)
    } else {
      VStack(spacing: 8) {
        ForEach(viewModel.recipes) { recipe in
          NavigationLink {
            MealDetailView(viewModel: viewModel, recipe: recipe)
          } label: {
            MealRecipeRow(recipe: recipe)
          }
          .buttonStyle(.plain)
        }
      }
      .padding(.top, 38)
    }
  }
}

private struct MealRecipeRow: View {
  let recipe: WatchRecipeSummary

  var body: some View {
    HStack(spacing: 8) {
      recipeImage

      VStack(alignment: .leading, spacing: 3) {
        Text(recipe.name)
          .font(.system(size: 7.5, weight: .bold))
          .foregroundStyle(.white)
          .lineLimit(1)
          .minimumScaleFactor(0.7)

        Text(recipe.category.capitalized)
          .font(.system(size: 6, weight: .regular))
          .foregroundStyle(MealsTheme.muted)
          .lineLimit(1)
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      HStack(alignment: .firstTextBaseline, spacing: 2) {
        Text(recipe.calories.map(String.init) ?? "--")
          .font(.system(size: 7.5, weight: .bold))
          .foregroundStyle(MealsTheme.lime)
        Text("Kcal")
          .font(.system(size: 5.5, weight: .regular))
          .foregroundStyle(MealsTheme.muted)
      }
    }
    .padding(.horizontal, 8)
    .frame(width: 168, height: 39)
    .background(
      MealsTheme.card,
      in: RoundedRectangle(cornerRadius: 12, style: .continuous)
    )
    .overlay {
      RoundedRectangle(cornerRadius: 12, style: .continuous)
        .stroke(MealsTheme.border, lineWidth: 1)
    }
  }

  @ViewBuilder
  private var recipeImage: some View {
    AsyncImage(url: resolvedImageURL) { phase in
      switch phase {
      case .success(let image):
        image
          .resizable()
          .scaledToFill()
      default:
        ZStack {
          Color.white.opacity(0.9)
          Image(systemName: "fork.knife")
            .font(.system(size: 8, weight: .semibold))
            .foregroundStyle(.black)
        }
      }
    }
    .frame(width: 24, height: 24)
    .clipShape(Circle())
    .overlay(Circle().stroke(Color.white.opacity(0.25), lineWidth: 0.5))
  }

  private var resolvedImageURL: URL? {
    guard let imageURL = recipe.imageURL, !imageURL.isEmpty else { return nil }
    if let absoluteURL = URL(string: imageURL), absoluteURL.scheme != nil {
      return absoluteURL
    }
    return URL(string: "https://willizo.com" + (imageURL.hasPrefix("/") ? imageURL : "/\(imageURL)"))
  }
}

private struct MealsDesignCanvas<Content: View>: View {
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

private enum MealsTheme {
  static let lime = Color(red: 212 / 255, green: 1, blue: 0)
  static let background = Color(red: 15 / 255, green: 15 / 255, blue: 15 / 255)
  static let card = Color(red: 24 / 255, green: 24 / 255, blue: 27 / 255).opacity(0.5)
  static let border = Color(red: 39 / 255, green: 39 / 255, blue: 42 / 255)
  static let muted = Color(red: 161 / 255, green: 161 / 255, blue: 170 / 255)
}
