class Constants {
  /// The electricity price of each country, in kW/Hs. Sourced from Statista,
  /// current as of September 2020. https://www.statista.com/aboutus/trust
  static const ELECTRICITY_PRICES = {
    'Australia': 0.32,
    'Argentina': 0.077,
    'Belgium': 0.39,
    'Brazil': 0.15,
    'China': 0.1,
    'Cyprus': 0.27,
    'Denmark': 0.42,
    'France': 0.28,
    'Germany': 0.46,
    'India': 0.1,
    'Indonesia': 0.13,
    'Iran': 0.013,
    'Ireland': 0.35,
    'Italy': 0.33,
    'Kenya': 0.27,
    'Japan': 0.33,
    'Mexico': 0.1,
    'New Zealand': 0.31,
    'Nigeria': 0.077,
    'Poland': 0.24,
    'Portugal': 0.35,
    'Qatar': 0.039,
    'Russia': 0.077,
    'Rwanda': 0.33,
    'Saudi Arabia': 0.064,
    'Singapore': 0.21,
    'South Africa': 0.19,
    'Spain': 0.31,
    'Turkey': 0.12,
    'UK': 0.33,
    'USA': 0.19,
  };

  static const PROCESSOR_TYPES = ['ASIC', 'GPU', 'CPU'];

  /// List of processors of format [processor]: [Cost, Power, SHA256, Ethash, RandomX]
  static const PROCESSORS = {
    // Price data from Amazon, Cryptocompare.com and various other online 
    // sources (converted to AUD on 09/05/2021), other data from nicehash.com
    'ASIC': {
      'BITMAIN AntMiner S19 Pro': [22933, 3250, 110000000, 0, 0],
      'BITMAIN AntMiner S19': [20830, 3250, 95000000, 0, 0],
      'BITMAIN AntMiner S17 Pro': [15971, 1975, 84000000, 0, 0],
      'BITMAIN AntMiner S17+': [15925, 2920, 80000000, 0, 0],
      'BITMAIN AntMiner S17': [3187, 2385, 85000000, 0, 0],
      'BITMAIN AntMine S17e': [1019, 2880, 64000000, 0, 0],
      'BITMAIN AntMiner T17+': [2410, 3200, 73000000, 0, 0],
      'BITMAIN AntMiner T17': [876, 2200, 60000000, 0, 0],
      'BITMAIN AntMiner T17e': [887, 2915, 53000000, 0, 0],
      'Innosilicon T3+ 57T': [2124, 3300, 57000000, 0],
      'MicroBT Whatsminer M31S': [2486, 3220, 70000000, 0, 0],
      'MicroBT Whatsminer M30S': [3436, 3268, 86000000, 0, 0],
      'MicroBT Whatsminer M21S': [2293, 3360, 56000000, 0, 0],
      'MicroBT Whatsminer M20S': [2952, 3360, 68000000, 0, 0],
      'MicroBT Whatsminer M10S': [2558, 3500, 55000000, 0, 0],
    },
    'GPU': {
      'AMD Radeon VII': [3599, 220, 0, 90.56, 0.0017],
      'AMD RX 6900 XT': [2799, 220, 0, 64, 0],
      'AMD RX 6800 XT': [1999, 190, 0, 64.4, 0],
      'AMD RX 6800': [1399, 175, 0, 63.4, 0],
      'AMD RX 6700 XT': [1827, 170, 0, 47, 0],
      'AMD RX 5700 XT': [1769, 140, 0, 54.76, 0],
      'AMD RX 5700': [569, 160, 0, 53.56, 0],
      'AMD RX 5600 XT': [1567, 100, 0, 37, 0],
      'NVIDIA A100': [22460, 210, 0, 171, 0],
      'NVIDIA P104-100': [1240.64, 120, 0, 37, 0],
      'NVIDIA P102-100': [1016.77, 190, 0, 47.56, 0],
      'NVIDIA RTX 3090': [5069, 285, 0, 120, 0],
      'NVIDIA RTX 3080': [3099, 220, 0, 96, 0],
      'NVIDIA RTX 3070': [2099, 120, 0, 29.53, 0],
      'NVIDIA RTX 3060 Ti': [1499, 115, 0, 60.5, 0],
      'NVIDIA RTX 3060': [1399, 115, 0, 49, 0],
      'NVIDIA RTX 2080 Ti': [2750, 230, 0, 59.21, 0],
      'NVIDIA RTX 2080': [1875, 108, 0, 43, 0],
      'NVIDIA RTX 2070': [800, 110, 0, 42.7, 0],
      'NVIDIA GTX 1080 Ti': [1200, 170, 0, 45.69, 0.0009],
      'NVIDIA TITAN V': [4699, 160, 0, 78.2, 0],
      'NVIDIA TITAN RTX': [3847, 250, 0, 66, 0],
      'NVIDIA TITAN XP': [1889, 240, 0, 45.49, 0],
    },
    'CPU': {
      'AMD EPYC 7742': [22900, 225, 0, 0, 0.039],
      'AMD EPYC 7601': [6058.22, 180, 0, 0, 0.0283],
      'AMD EPYC 7551': [4868.33, 180, 0, 0, 0.0289],
      'AMD EPYC 7402P': [2881.62, 200, 0, 0, 0.023],
      'AMD EPYC 7402': [3143.71, 200, 0, 0, 0.023],
      'AMD EPYC 7352': [1567.93, 155, 0, 0, 0.0215],
      'AMD EPYC 7302': [1952.51, 155, 0, 0, 0.0244],
      'AMD Threadripper 3990X': [5986.96, 280, 0, 0, 0.053],
      'AMD Threadripper 3970X': [2899, 280, 0, 0, 0.032],
      'AMD Threadripper 3960X': [2099, 280, 0, 0, 0.0268],
      'AMD Threadripper 2990WX': [2335.15, 250, 0, 0, 0.1451],
      'AMD Ryzen 9 5950X': [1346, 105, 0, 0, 0.018],
      'AMD Ryzen 9 5900X': [1061.95, 105, 0, 0, 0.014],
      'AMD Ryzen 9 3950X': [1103.94, 105, 0, 0, 0.01651],
      'AMD Ryzen 9 3900XT': [709.19, 105, 0, 0, 0.0131],
      'AMD Ryzen 9 3900X': [725, 105, 0, 0, 0.01317],
      'AMD Ryzen 7 5800X': [606.90, 105, 0, 0, 0.010],
      'AMD Ryzen 7 3800X': [465, 105, 0, 0, 0.0092],
      'AMD Ryzen 7 3700X': [444.83, 105, 0, 0, 0.0092],
      'AMD Ryzen 5 5600X': [491, 65, 0, 0, 0.008],
      'AMD Ryzen 5 3600X': [339, 95, 0, 0, 0.007],
      'Intel i9-10900KF': [659, 125, 0, 0, 0.0072],
      'Intel i9-10900K': [699, 125, 0, 0, 0.0071],
      'Intel i9-9980XE': [1923.72, 95, 0, 0, 0.0098],
      'Intel i9-7980XE': [3137.99, 95, 0, 0, 0.0083],
      'Intel i9-7940X': [1069.12, 95, 0, 0, 0.0064],
      'Intel i9-7920X': [2976.50, 95, 0, 0, 0.00704],
      'Intel i9-7900X': [1523.59, 95, 0, 0, 0.00588],
      'Intel i7-10700KF': [435, 95, 0, 0, 0.0064],
      'Intel i7-10700K': [477, 95, 0, 0, 0.0063],
    },
  };

  static const int WATTS_IN_KILOWATT = 1000;
  static const MINUTES_IN_DAY = 1440;
  static const int HOURS_IN_DAY = 24;
  static const DAYS_IN_TWO_YEARS = 1825;

  static const NETWORK_HASHRATE = [149000000045000.0, 580230000.0, 2566]; // TODO: Make this variable per day
  static const BLOCK_REWARD = [6.25, 2.0, 1.03];
  static const BLOCKTIME = [10.0, 0.25, 2];
}
