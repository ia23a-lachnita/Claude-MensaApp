/**
 * Utility functions for menu/menuplan operations
 */

/**
 * Sorts menu plans by date in ascending order (today first, then tomorrow, etc.)
 * @param {Array} menuPlans - Array of menu plan objects with 'datum' field
 * @returns {Array} Sorted array of menu plans
 */
export const sortMenuPlansByDate = (menuPlans) => {
  if (!Array.isArray(menuPlans)) {
    return [];
  }
  
  return [...menuPlans].sort((a, b) => {
    const dateA = new Date(a.datum);
    const dateB = new Date(b.datum);
    return dateA - dateB;
  });
};

/**
 * Filters menu plans to only include future dates (today and onward)
 * @param {Array} menuPlans - Array of menu plan objects with 'datum' field
 * @returns {Array} Filtered array of menu plans
 */
export const filterFutureMenuPlans = (menuPlans) => {
  if (!Array.isArray(menuPlans)) {
    return [];
  }
  
  const today = new Date();
  today.setHours(0, 0, 0, 0); // Reset time to start of day
  
  return menuPlans.filter(menu => {
    const menuDate = new Date(menu.datum);
    menuDate.setHours(0, 0, 0, 0);
    return menuDate >= today;
  });
};

/**
 * Gets the next N menu plans from today onwards, sorted by date
 * @param {Array} menuPlans - Array of menu plan objects with 'datum' field
 * @param {number} count - Number of menu plans to return
 * @returns {Array} Array of next menu plans
 */
export const getNextMenuPlans = (menuPlans, count = 3) => {
  const futureMenus = filterFutureMenuPlans(menuPlans);
  const sortedMenus = sortMenuPlansByDate(futureMenus);
  return sortedMenus.slice(0, count);
};