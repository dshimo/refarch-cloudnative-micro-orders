package orders;

import java.util.List;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import orders.model.Order;

@Repository
public interface OrdersRepository extends CrudRepository<Order, String> {
	List<Order> findByCustomerIdOrderByDateDesc(String customerId);
}
