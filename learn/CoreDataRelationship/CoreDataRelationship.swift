import SwiftUI
import CoreData
#Preview {
    CoreDataRView()
}


/*
 There are 3 entity
 1. BusinessEntity
 2. DepartamentEntity
 3. EmployeeEntity
 */

class CoreDataRelationshipManager{
    static let instance = CoreDataRelationshipManager()
    let container: NSPersistentContainer
    let contex: NSManagedObjectContext
    
    init(){
        container = NSPersistentContainer(name: "CoreDataRelationshipContainer")
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                print("ERROR: \(error), \(error.userInfo)")
            }
        }
        contex = container.viewContext
    }
    
    func saveData(){
        do{
            try contex.save()
            print("Saved successfully")
        } catch let error{
            print("ERROR Saving: \(error), \(error.localizedDescription)")
        }
    }
}

class CoreDataRelationshipViewModel: ObservableObject{
    let manager = CoreDataRelationshipManager.instance
    
    @Published var businesses: [BusinessEntity] = []
    @Published var departments: [DepartmentEntity] = []
    @Published var employees: [EmployeeEntity] = []
    
    init(){
        getBusiness()
        getDepartments()
        getEmployees()
    }
    
    func getBusiness(){
        let request: NSFetchRequest<BusinessEntity> = BusinessEntity.fetchRequest()
        
        //sorting
        let sort: NSSortDescriptor = NSSortDescriptor(
            keyPath: \BusinessEntity.name,
            ascending: true)
        request.sortDescriptors = [sort]
        
        
        //filter
        // %@ это получается ссылка на args = "Apple"
//        let filter: NSPredicate = NSPredicate(format: "name == %@", "Apple")
//        request.predicate = filter
        
        
        
        do{
            businesses = try manager.contex.fetch(request)
        } catch let error{
            print("ERROR: \(error), \(error.localizedDescription)")
        }
    }
    
    func getDepartments(){
        let request: NSFetchRequest<DepartmentEntity> = DepartmentEntity.fetchRequest()
        do{
            departments = try manager.contex.fetch(request)
        } catch let error{
            print("ERROR: \(error), \(error.localizedDescription)")
        }
    }
    
    func getEmployees(){
        let request: NSFetchRequest<EmployeeEntity> = EmployeeEntity.fetchRequest()
        do{
            employees = try manager.contex.fetch(request)
        } catch let error{
            print("ERROR: \(error), \(error.localizedDescription)")
        }
    }
    
    func getEmployees(forBusiness business: BusinessEntity){
        let request: NSFetchRequest<EmployeeEntity> = EmployeeEntity.fetchRequest()
        
        let filter = NSPredicate(format: "business == %@", business)
        request.predicate = filter
        
        do{
            employees = try manager.contex.fetch(request)
        } catch let error{
            print("ERROR: \(error), \(error.localizedDescription)")
        }
    }
    
    func updateBusiness(){
        let existingBusiness = businesses[2]
        existingBusiness.addToDepartments(departments[1])
        save()
    }
    
    func addBusiness(name: String){
        let newBusiness = BusinessEntity(context: manager.contex)
        newBusiness.name = name
        
        
        //add exicsting depratments o the new business
//        newBusiness.departments = [departments[0], departments[1]]
        
        //add exicsting employees to the new business
//        newBusiness.employees = [employees[1]]
        
        //add new business to existing department
        //newBusiness.addToDepartments(<#T##value: DepartmentEntity##DepartmentEntity#>)
        
        //add new business to existing employee
        //newBusiness.addToEmployees(<#T##value: EmployeeEntity##EmployeeEntity#>)
        
        save()
    }
    
    
    func addDepartment(name: String){
        let newDepartment = DepartmentEntity(context: manager.contex)
        newDepartment.name = name
        
        newDepartment.businesses = [businesses[2], businesses[0], businesses[1]]
        
        /*
         I want to add Chris to the new Department
         i can do it like that
        newDepartment.employees = [employees[1]]
         
         but there have another way
         newDepartment.addToEmployees(employees[1])
        */
        
        newDepartment.addToEmployees(employees[1])
        
        
        save()
    }
    
    
    func addEmployee(name: String, age: Int, date: Date? = Date()){
        let newEmployee = EmployeeEntity(context: manager.contex)
        newEmployee.name = name
        newEmployee.age = Int16(age)
        newEmployee.dateJoined = date
        
        newEmployee.busines = businesses[2]
        newEmployee.department = departments[1]
        save()
    }
    
    func deleteDapertment(){
        /*
         Delete Rule in inspector
         допустим в DepartamentEntity relationship с employees
         
         nullify - получается когда удалаяется Департамент все связи снизу просто удаляют у себя его как связ но продолжают существовать сами по себе.
         cascade
         
         cascade - когда Департамент удаляется все employees тоже удаляются с базы и они пропадают в других где была связь employee
         
         deny - не дает удалить Департамент пока все employee не будут удалены
         */
        let department = departments[2]
        manager.contex.delete(department)
        save()
    }
    
    func save() {
        businesses.removeAll()
        departments.removeAll()
        employees.removeAll()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.manager.saveData()
            self.getBusiness()
            self.getDepartments()
            self.getEmployees()
        }
        
    }
    
    func clearCoreData() {
        let entities = ["DepartmentEntity"]
        let context = CoreDataRelationshipManager.instance.contex
        
        do {
            for entity in entities {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                try context.execute(deleteRequest)
            }
            try context.save()
            print("CoreData очищена")
        } catch {
            print("Ошибка при очистке CoreData: \(error.localizedDescription)")
        }
    }
    
    func clearDepartment(named departmentName: String) {
        let fetchRequest: NSFetchRequest<DepartmentEntity> = DepartmentEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", departmentName)
        
        let context = CoreDataRelationshipManager.instance.contex
        
        do {
            if let department = try context.fetch(fetchRequest).last {
                context.delete(department)
                try context.save()
                print("Department \(departmentName) deleted successfully")
            } else {
                print("Department \(departmentName) not found")
            }
        } catch {
            print("Ошибка при очистке CoreData: \(error.localizedDescription)")
        }
    }


}

struct CoreDataRView: View {
    
    
    @StateObject var vm = CoreDataRelationshipViewModel()
    let text: String = "Dostan"
    let age: Int = 18
    
    
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(spacing: 20){
                    Button{
//                        vm.addBusiness(name: "Facebook")
//                        vm.addDepartment(name: "Finance")
//                        vm.addEmployee(name: text, age: age)
//                        vm.clearDepartment(named: "Engineering")
//                        vm.getEmployees(forBusiness: vm.businesses[0])
                    }label: {
                        Text("Perform Action")
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                    
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(alignment: .top){
                            ForEach(vm.businesses){business in
                                BusinessView(entity: business)
                            }
                        }
                    }
                    
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(alignment: .top){
                            ForEach(vm.departments){department in
                                DepartmentView(entity: department)
                            }
                        }
                    }
                    
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(alignment: .top){
                            ForEach(vm.employees){eployee in
                                EmployeeView(entity: eployee)
                            }
                        }
                    }
                    
                }
                .padding()
                
            }
            .navigationTitle("Relationships")
        }
    }
}


struct BusinessView: View{
    
    let entity: BusinessEntity
    
    var body: some View{
        VStack(alignment: .leading, spacing: 20){
            Text("Name: \(entity.name ?? "")")
                .bold()
            
            if let deparments = entity.departments?.allObjects as? [DepartmentEntity]{
                Text("Deparments: ")
                    .bold()
                ForEach(deparments){department in
                    Text(department.name ?? "")
                }
            }
            if let employees = entity.employees?.allObjects as? [EmployeeEntity]{
                Text("Employees: ")
                    .bold()
                ForEach(employees){employee in
                    Text(employee.name ?? "")
                }
            }
        }
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .shadow(radius: 10)
        
    }
}


struct DepartmentView: View{
    
    let entity: DepartmentEntity
    
    var body: some View{
        VStack(alignment: .leading, spacing: 20){
            Text("Name: \(entity.name ?? "")")
                .bold()
            
            
            if let businesses = entity.businesses?.allObjects as? [BusinessEntity]{
                Text("Businesses: ")
                    .bold()
                ForEach(businesses){business in
                    Text(business.name ?? "")
                }
            }
            if let employees = entity.employees?.allObjects as? [EmployeeEntity]{
                Text("Employees: ")
                    .bold()
                ForEach(employees){employee in
                    Text(employee.name ?? "")
                }
            }
        }
        .padding()
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color.green.opacity(0.2))
        .cornerRadius(10)
        .shadow(radius: 10)
        
    }
}


struct EmployeeView: View{
    
    let entity: EmployeeEntity
    
    var body: some View{
        VStack(alignment: .leading, spacing: 20){
            Text("Name: \(entity.name ?? "")")
                .bold()
            
            Text("Age: \(entity.age)" )
            Text("Date joined: \(String(describing: entity.dateJoined!))" )
            
            Text("Business: ")
                .bold()
            Text(entity.busines?.name ?? "")
            
            Text("Departament: ")
                .bold()
            Text(entity.department?.name ?? "")
           
        }
        .padding()
        .frame(maxWidth: 400, alignment: .leading)
        .background(Color.red.opacity(0.2))
        .cornerRadius(10)
        .shadow(radius: 10)
        
    }
}


