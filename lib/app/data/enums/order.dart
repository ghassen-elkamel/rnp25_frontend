enum Order {
  ASC,
  DESC,
}

extension InverseOrder on Order {
  Order get inv {
    if (this == Order.ASC) {
      return Order.DESC;
    }
    return Order.ASC;
  }
}
