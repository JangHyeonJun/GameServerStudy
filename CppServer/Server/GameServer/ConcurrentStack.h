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

  // 1) �� ��常���
  // 2) �� ����� next = head
  // 3) head = �� ��� 
  
  // [ ][ ][ ][ ][ ][ ]
  // [head]
  void Push(const T& value)
  {
    Node* node = new Node(value);
    node->next = _head;

    // �Ʒ� while ���� �ᱹ �� �ڵ�� �Ȱ���
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

  // 1) head �б�
  // 2) head->next �б�
  // 3) head = head->next
  // 4) data �����ؼ� ��ȯ
  // 5) ������ ��带 ����

  // [ ][ ][ ][ ][ ][ ]
  // [head]
  bool TryPop(T& value)
  {
    Node* oldHead = _head;

    // �Ʒ� while ���� �ᱹ �� �ڵ�� �Ȱ���
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

    // ���ܰ� �߻����� �ʴ´ٰ� ����
    value = oldHead->data;
    
    
    // ��� ���� ����
    // C#, Java��� ���⼭ �Ű澵 �͵� ����..
    //delete oldHead;

    return true;
  }

private:

  // [ ][ ][ ][ ][ ][ ]
  // [head]
  atomic<Node*> _head;
};