enum Filter { glutenFree, lactoseFree, vegetarian, vegan }

filterToString(Filter filter) {
  switch (filter) {
    case Filter.glutenFree:
      return "Gluten-free";
    case Filter.lactoseFree:
      return "Lactose-free";
    case Filter.vegetarian:
      return "Vegetarian";
    case Filter.vegan:
      return "Vegan";
    default:
      return "";
  }
}

const defaultFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegan: false,
  Filter.vegetarian: false,
};
