@IsTest
public class TestDataFactory {
    public static TestCaseFactory CASEOBJ = new TestCaseFactory();
    public static TestTodoFactory TODO = new TestTodoFactory();
    public static TestSubTodoFactory SUBTODO = new TestSubTodoFactory();

    public class TestCaseFactory{
        public Case createDummyCase(String subject, String origin, Boolean needInsert){
            Case caseObj = new Case();
            caseObj.Subject = subject;
            caseObj.Origin = origin;
            if(needInsert) insert caseObj;
            return caseObj;
        }
    }

    public class TestTodoFactory{
        public To_Do__c createDummyTodo(String name, Boolean needInsert){
            To_Do__c todo = new To_Do__c();
            todo.Name = name;
            if(needInsert) insert todo;
            return todo;
        }
    
        public List<To_Do__c> createDummyTodoList(String name, Integer count, Boolean needInsert){
            List<To_Do__c> todos = new List<To_Do__c>();
            for (Integer i = 0; i <= count; i++) {
                todos.add(createDummyTodo(name, false));
            }
            if(needInsert) insert todos;
            return todos;
        }
    }

    public class TestSubTodoFactory{
        public Sub_To_Do__c createDummySubTodo(String name, String todo, Boolean needInsert){
            Sub_To_Do__c subTodo = new Sub_To_Do__c();
            subTodo.Name = name;
            subTodo.To_Do__c = todo;
            if(needInsert) insert subTodo;
            return subTodo;
        }
       
        public List<Sub_To_Do__c> createDummySubTodoList(String name, String todo, Integer count, Boolean needInsert){
            List<Sub_To_Do__c> subTodos = new List<Sub_To_Do__c>();
            for (Integer i = 0; i <= count; i++) {
                subTodos.add(createDummySubTodo(name, todo, false));
            }
            if(needInsert) insert subTodos;
            return subTodos;
        }
    }
}