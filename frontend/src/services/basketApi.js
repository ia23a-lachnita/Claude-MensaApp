import api from './api';

export const basketService = {
  // Validate basket contents for a specific pickup date
  validateBasket: async (basketData) => {
    try {
      const response = await api.post('/basket/validate', basketData);
      return response.data;
    } catch (error) {
      console.error('Basket validation error:', error);
      throw error;
    }
  }
};

// Helper function to convert cart state to basket validation request format
export const convertCartToBasketRequest = (cartState) => {
  const items = (cartState.items || []).map(item => ({
    gerichtId: item.gericht.id,
    anzahl: item.anzahl,
    urspruenglichesDatum: item.originalMenuDate
  }));

  return {
    items,
    gewuenschtesAbholDatum: cartState.abholDatum
  };
};