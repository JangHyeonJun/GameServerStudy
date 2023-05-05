#pragma once

#include <mutex>

template<typename T>
class LockFreeStack
{
  struct Node
  {
    Node(const T& value) : data(value) {}

    T data;
    Node* next;
  };


public:

  // 1) 새 노드만들기
  // 2) 새 노드의 next = head
  // 3) head = 새 노드 
  
  // [ ][ ][ ][ ][ ][ ]
  // [head]
  void Push(const T& value)
  {
    Node* node = new Node(value);
    node->next = _head;

    // 아래 while 문이 결국 이 코드랑 똑같음
    /*if (_head == node->next)
    {
      _head = node;
      return true;
    }
    else
    {
      node->next = _head;
      return false;
    }*/

    while (_head.compare_exchange_weak(node->next, node) == false)
    {
      node->next = _head;
    }
    
    _head = node;
  }

  // 1) head 읽기
  // 2) head->next 읽기
  // 3) head = head->next
  // 4) data 추출해서 반환
  // 5) 추출한 노드를 삭제

  // [ ][ ][ ][ ][ ][ ]
  // [head]
  bool TryPop(T& value)
  {
    Node* oldHead = _head;

    // 아래 while 문이 결국 이 코드랑 똑같음
    /*if (_head == oldHead)
    {
      _head = oldHead->next;
      return true;
    }
    else
    {
      oldHead = _head;
      return false;
    }*/

    while (oldHead && _head.compare_exchange_weak(oldHead, oldHead->next) == false)
    {
      oldHead = _head;
    }

    if (oldHead == nullptr)
      return false;

    // 예외가 발생하지 않는다고 가정
    value = oldHead->data;
    
    
    // 잠시 삭제 보류
    // C#, Java라면 여기서 신경쓸 것도 없을..
    //delete oldHead;

    return true;
  }

private:

  // [ ][ ][ ][ ][ ][ ]
  // [head]
  atomic<Node*> _head;
};