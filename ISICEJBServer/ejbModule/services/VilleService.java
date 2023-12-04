package services;

import java.util.List;

import dao.IDaoLocale;
import dao.IDaoRemote;
import entities.Ville;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;

@Stateless(name = "kenza")
public class VilleService implements IDaoRemote<Ville>, IDaoLocale<Ville> {
	
	@PersistenceContext
	private EntityManager em;

	@Override
	public Ville create(Ville o) {
		em.persist(o);
		return o;
	}

	@Override
	public boolean delete(Ville o) {
		em.remove(o);
		return true;
	}

	@Override
	public Ville update(Ville o) {
		 try {
	            return em.merge(o);
	        } catch (Exception e) {
	            e.printStackTrace(); 
	            return null;
	        }
	}

	@Override
	public Ville findById(int id) {
		// TODO Auto-generated method stub
		return em.find(Ville.class, id);
	}

	@Override
	public List<Ville> findAll() {
		Query query = em.createQuery("select v from Ville v");
		return query.getResultList();
	}

}
