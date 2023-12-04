package controllers;

import jakarta.ejb.EJB;
import jakarta.persistence.PersistenceException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.ConstraintViolationException;

import java.io.IOException;
import java.util.List;

import dao.IDaoLocale;
import entities.Ville;

/**
 * Servlet implementation class VilleController
 */
public class VilleController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@EJB(beanName = "kenza")
	private IDaoLocale<Ville> ejb;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public VilleController() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");

		if ("delete".equals(action)) {
		    try {
		        int villeIdToDelete = Integer.parseInt(request.getParameter("villeId"));
		        Ville villeToDelete = ejb.findById(villeIdToDelete);

		        if (villeToDelete != null) {
		            boolean deletionSuccess = ejb.delete(villeToDelete);

		            if (!deletionSuccess) {
		                request.setAttribute("errorMessage", "Impossible de supprimer cette ville. Elle est liée à des hôtels.");
		            }
		        }
		    } catch (PersistenceException | NumberFormatException e) {
		        if (e.getCause() instanceof ConstraintViolationException) {
		            request.setAttribute("errorMessage", "Impossible de supprimer cette ville. Elle est liée à des hôtels.");
		        } else {
		            throw new ServletException("Error deleting city", e);
		        }
		    } catch (Exception e) {
		        throw new ServletException("Error deleting city", e);
		    }
		}else if ("update".equals(action)) {
	        try {
	            int villeIdToUpdate = Integer.parseInt(request.getParameter("villeId"));
	            String nom = request.getParameter("ville");

	            Ville villeToUpdate = ejb.findById(villeIdToUpdate);
	            villeToUpdate.setNom(nom);

	            Ville updatedVille = ejb.update(villeToUpdate);

	            if (updatedVille == null) {
	                request.setAttribute("errorMessage", "Impossible de mettre à jour cette ville.");
	            }
	        } catch (NumberFormatException e) {
	            throw new ServletException("Error updating city", e);
	        } catch (Exception e) {
	            throw new ServletException("Error updating city", e);
	        }
	    }

		List<Ville> villes = ejb.findAll();
		request.setAttribute("villes", villes);

		RequestDispatcher dispatcher = request.getRequestDispatcher("ville.jsp");
		dispatcher.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		doGet(request, response);
	}
}