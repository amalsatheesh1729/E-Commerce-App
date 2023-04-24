package com.example.demo;


import org.springframework.data.elasticsearch.annotations.Query;
import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;
import org.springframework.stereotype.Repository;


public interface ProductRepository extends ElasticsearchRepository<Product,Integer>{

	
	//customizing query using Elastic DSL 
	@Query("{\"bool\":{\"should\":[{\"regexp\":{\"name\":\".*?0.*\"}},{\"match\":{\"description\":\"?0\"}}]}}")
	Iterable<Product> search(String search);
	 
	
	Iterable<Product> findAllByProductCategory(String category);


	Iterable<Product> findAllByAvailablequantityLessThan(int i);
	 
}
